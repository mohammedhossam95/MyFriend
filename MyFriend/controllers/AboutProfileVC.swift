//
//  AboutProfileVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class AboutProfileVC: BaseViewController {

    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var nameAboutMeLbl: UILabel!
    @IBOutlet weak var aboutMeLbl: UILabel!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var interestsLbl: UILabel!
    @IBOutlet weak var hobies1Lbl: UILabel!

    var profileData = Profile()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.showLoading()
        handleProfileRefresh()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        handleProfileRefresh()
    }
    
    func handleProfileRefresh()  {
        ApiCalls.getProfile { (error: Error?, profile: Profile?) in
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
