//
//  userAboutVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/26/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class userAboutVC: UIViewController {

    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var nameAboutMeLbl: UILabel!
    @IBOutlet weak var aboutMeLbl: UILabel!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var interestsLbl: UILabel!
    @IBOutlet weak var hobies1Lbl: UILabel!
    
    var profileData = Profile()
    static var userId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleProfileRefresh(friend_id: userAboutVC.userId)
         self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func handleProfileRefresh(friend_id: Int)  {
        ApiCalls.getUserProfile(friend_id: userAboutVC.userId) { (error: Error?, profile: Profile?) in
            if let profile = profile{
                self.profileData = profile
                self.updateUI(profile: self.profileData)
            }
        }
    }
    func updateUI(profile: Profile)  {
        
        self.nameAboutMeLbl.text = "About " + profileData.username
        self.aboutMeLbl.text = profileData.bio
        self.workLbl.text = profileData.work
        self.interestsLbl.text = profileData.interest_in
        self.hobies1Lbl.text = profileData.hobbies
        
    }
    
    func setupView() {
        aboutView.layer.cornerRadius = 35.0
        aboutView.clipsToBounds = true
        aboutView.layer.borderWidth = 1
        aboutView.layer.masksToBounds = false
        aboutView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
    }
    
    
}
