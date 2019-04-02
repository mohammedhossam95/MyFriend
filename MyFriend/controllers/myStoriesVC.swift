//
//  myStoriesVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia
import GravitySliderFlowLayout

class myStoriesVC: BaseViewController {

    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var followersTable: UITableView!
    @IBOutlet weak var storiesCollection: UICollectionView!
    @IBOutlet weak var storyView: UILabel!
    
    var likesArr = [RandomUser]()
    var followersArr = [HomePost]()
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.85
    let collectionViewCellWidthCoefficient: CGFloat = 0.35
//    0.55
    
    let productCellIdentifier = "MyStoryCell"
    let CellIdentifier = "MyStoryCell"
    
    var player: AVPlayer!
    
    var isLoading = false
    var current_page = 1
    var last_page = 1
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handlefollowersRefresh), for: .valueChanged)
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        followersTable.addSubview(refresher)
        storiesCollection.addSubview(refresher)
        self.handlefollowersRefresh()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: storiesCollection.frame.size.width * collectionViewCellWidthCoefficient, height: storiesCollection.frame.size.height * collectionViewCellHeightCoefficient))
        storiesCollection.collectionViewLayout = gravitySliderLayout
        storiesCollection.dataSource = self
        storiesCollection.delegate = self
    }
    
    private func configureProductCell(_ cell: MyStoryCell, for indexPath: IndexPath) {
        
    }
    
    private func animateChangingTitle(for indexPath: IndexPath) {
        UIView.transition(with: followersTable, duration: 0.3, options: .transitionCrossDissolve, animations: {
           // self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
        }, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handlefollowersRefresh()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getMyStories { (error: Error?, randomImages: [HomePost]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages {
                if randomImages.isEmpty {
                    self.storiesCollection.isHidden = true
                    self.hideLoading()
                }else{
                    self.followersArr = randomImages
                    self.hideLoading()
                    self.storiesCollection.reloadData()
                    self.current_page = 1
                    self.last_page = last_page
                }
                
            }
        }
    }
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        
        ApiCalls.getMyStories (page: current_page+1) { (error: Error?, randomImages: [HomePost]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages{
                self.followersArr.append(contentsOf: randomImages)
                self.storiesCollection.reloadData()
                self.current_page += 1
                self.last_page = last_page
                self.hideLoading()
            }
        }
    }
    
    @objc func handleViewsRefresh(id: Int)  {
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getStoryViews(story_id: id) { (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages {
                if randomImages.isEmpty {
                    self.hideLoading()
                }else{
                    self.likesArr = randomImages
                    self.hideLoading()
                    self.followersTable.reloadData()
                    self.current_page = 1
                    self.last_page = last_page
                }
                
            }
        }
    }
    
    func LoadViewsMore(id: Int) {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        
        ApiCalls.getStoryViews(page: current_page+1, story_id: id) { (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages{
                self.likesArr.append(contentsOf: randomImages)
                self.followersTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                self.hideLoading()
            }
        }
    }
    func openProfileFromHome(Id:Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
        VC.userId = Id
        userAboutVC.userId = Id
        userGallaryVC.id = Id
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    private func handleDelete(story: HomePost, indexPath: IndexPath) {
        self.showLoading()
        ApiCalls.DeleteStory(story: story) { (error: Error?, success : Bool, status: String) in
            if success {
                self.hideLoading()
                if let index = self.followersArr.firstIndex(of: story){
                    self.followersArr.remove(at: index)
                    self.storiesCollection.deleteItems(at: [indexPath])
                    self.storiesCollection.reloadData()
                }else{
                    print("Not available index")
                }
                
            }else {
                self.hideLoading()
                self.showAlertError(title: status)
            }
            }
        }

}

extension myStoriesVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        cell.selectionStyle = .none
        let user = likesArr[indexPath.row]
       cell.configreCell(user: user)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openProfileFromHome(Id: self.likesArr[indexPath.row].userId)
    }
    
}
extension myStoriesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followersArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        let lastStory = followersArr[index]
        
        //if lastStory.type == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStoryCell", for: indexPath) as! MyStoryCell
            cell.configCell(story: lastStory)
            cell.deleteBtn = {
                
                let alertController = UIAlertController(title: "Confirm", message: "Are You sure to delete this story", preferredStyle: .alert)
                
                
                let okBtn = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.handleDelete(story: lastStory, indexPath: indexPath)
                }
                let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                
                self.navigationController?.present(alertController, animated: true, completion: nil)
                
            }
            cell.viewsBtn = {
                let index = self.followersArr[indexPath.row]
                self.storyView.text = "\(self.followersArr[indexPath.row].views) Views"
                self.handleViewsRefresh(id: index.id)
            }
            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStoryVideoCell", for: indexPath) as! MyStoryVideoCell
//            cell.configCell(story: lastStory)
//            cell.deleteBtn = {
//
//                let alertController = UIAlertController(title: "Confirm", message: "Are You sure to delete this story", preferredStyle: .alert)
//
//
//                let okBtn = UIAlertAction(title: "Ok", style: .default) { (action) in
//                    self.handleDelete(story: lastStory, indexPath: indexPath)
//                }
//                let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//
//                }
//                alertController.addAction(okBtn)
//                alertController.addAction(cancelBtn)
//
//                self.navigationController?.present(alertController, animated: true, completion: nil)
//
//            }
//            cell.viewsBtn = {
//                let index = self.followersArr[indexPath.row]
//                self.storyView.text = "\(self.followersArr[indexPath.row].views) Views"
//                self.handleViewsRefresh(id: index.id)
//            }
//            return cell
//        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 16) / 3
//        let wid = width > 100 ? 100 : width
//        return CGSize(width: wid, height: CGFloat(collectionView.bounds.height))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}

