//
//  ViewsVC.swift
//  MyFriend
//
//  Created by mohammed Hossam on 2/4/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ViewsVC: BaseViewController {
    
    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    var id = Int()
    @IBOutlet weak var likesTable: UITableView!
    
    var likesArr = [RandomUser]()
    
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
        likesTable.addSubview(refresher)
        self.handlefollowersRefresh()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func handlefollowersRefresh()  {
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getMyViews(gallery_id: id){ (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages {
                if randomImages.isEmpty {
                    self.likesTable.isHidden = true
                    self.hideLoading()
                }else{
                    self.likesArr = randomImages
                    self.hideLoading()
                    self.likesTable.reloadData()
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
        
        ApiCalls.getMyViews(page: current_page+1, gallery_id: 257) { (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages{
                self.likesArr.append(contentsOf: randomImages)
                self.likesTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                self.hideLoading()
            }
        }
    }
    func openProfileFromHome(Id:Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
        print(Id)
        VC.userId = Id
        userAboutVC.userId = Id
        userGallaryVC.id = Id
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension ViewsVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.likesArr.count
        if indexPath.row == count-1 {
            self.LoadMore()
        }
    }
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
