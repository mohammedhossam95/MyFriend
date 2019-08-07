//
//  UserAboutTableVC.swift
//  MyFriend
//
//  Created by MOHAMED HAMAD on 8/5/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class UserAboutTableVC: BaseTableViewController {
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var nameAboutMeLbl: UILabel!
    @IBOutlet weak var aboutMeLbl: UITextView!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var interestsLbl: UILabel!
    @IBOutlet weak var hobiesCV: UICollectionView!
    
    var profileData = Profile()
    var tags = [String]()
    static var userId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleProfileRefresh(friend_id: UserAboutTableVC.userId)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        hobiesCV.dataSource = self
        hobiesCV.delegate = self
        
        // Do any additional setup after loading the view.
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func handleProfileRefresh(friend_id: Int)  {
        ApiCalls.getUserProfile(friend_id: UserAboutTableVC.userId) { (error: Error?, profile: Profile?) in
            if let profile = profile{
                self.profileData = profile
                self.tags.removeAll()
                self.updateUI(profile: self.profileData)
            }
        }
    }
    func updateUI(profile: Profile)  {
        self.nameAboutMeLbl.text = "About " + profileData.username
        self.aboutMeLbl.text = profileData.bio
        self.workLbl.text = profileData.work
        self.interestsLbl.text = profileData.interest_in
        for key in profileData.hobbies {
            tags.append(key)
        }
        self.hobiesCV.reloadData()
        self.tableView.reloadData()
        self.hideLoading()
        
    }
    
    func setupView() {
        aboutView.layer.cornerRadius = 35.0
        aboutView.clipsToBounds = true
        aboutView.layer.borderWidth = 1
        aboutView.layer.masksToBounds = false
        aboutView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
    }
}

extension UserAboutTableVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case hobiesCV:
            return tags.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.titleLabel.text = tags[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tags[indexPath.item].width(withConstrainedHeight: 46.0, font: UIFont(name: "Montserrat-Regular", size: 17.0)!) + 50.0
        return CGSize(width: width, height: 40.0)
    }
}
