//
//  ProfileVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var contViewGallary: UIView!
    @IBOutlet weak var contViewAbout: UIView!
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var editinfoView: UIView!
    @IBOutlet weak var goView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var userProfilefollowers: UIButton!
    @IBOutlet weak var userProfilefollowings: UIButton!
    @IBOutlet weak var profileBio: UILabel!
    
    @IBOutlet weak var verifyImage: UIImageView!
    @IBOutlet weak var aboutlabel: UILabel!
    @IBOutlet weak var galleryLabel: UILabel!
    
    var UProfile = Profile()
    
    //        if let tabItems = tabBarController?.tabBar.items {
    //            // In this case we want to modify the badge number of the third tab:
    //            let tabItem = tabItems[3]
    //            tabItem.badgeValue = "8"
    //        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpecificLoading()
        self.setupView()
        self.handleProfileRefresh()
        
        
        self.beforChangeHappend()
        contViewGallary.isHidden = false
        galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        self.handleProfileRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getNotificationBadge { (userId: Int, status: String, exception: String) in
            DispatchQueue.main.async {
                if status != "false"{
                    print("ios true")
                }
            }
        }
    }
    func handleProfileRefresh()  {
        ApiCalls.getProfile { (error: Error?, profile: Profile?) in
            if let profile = profile{
                self.UProfile = profile
                self.updateUI(profile: self.UProfile)
            }
        }
        
    }
    func updateUI(profile: Profile)  {
        self.profileImage.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(profile.avatar)") {
            self.profileImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        if profile.verified == 0 {
            verifyImage.isHidden = true
        }else {
            verifyImage.isHidden = false
        }
        self.userProfileName.text = profile.username
        self.profileBio.text = profile.bio
        self.userProfilefollowers.setTitle("\(profile.followers) Followers", for: .normal)
        self.userProfilefollowings.setTitle("\(profile.following) Following", for: .normal)
        self.hideLoading()
        self.hideSpecificLoading()
    }
    
    @IBAction func previewGallery(_ sender: UIButton) {
        self.beforChangeHappend()
        galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        contViewGallary.isHidden = false
//        let vc = GallaryVC()
//        vc.handleGalleryRefresh()

    }
    @IBAction func previewEditInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        //VC.galleryPresenting = gallery
        self.navigationController?.pushViewController(VC, animated: true)
   
    }
    
    
    @IBAction func previewMyStories(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "myStoriesVC") as! myStoriesVC
        //VC.galleryPresenting = gallery
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    @IBAction func preview_Insights(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AnalysisVC") as! AnalysisVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func previewSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        //VC.galleryPresenting = gallery
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func previewAbout(_ sender: UIButton) {
        self.beforChangeHappend()
        aboutlabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        contViewAbout.isHidden = false
    }
    
    @IBAction func logoutPress(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Confirm", message: "Do you really want to logout...", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "Log Out", style: .default) { (action) in
            self.Logout()
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel btn")
        }
        
        alertController.addAction(cancelBtn)
        alertController.addAction(logout)
//        alertController.popoverPresentationController?.sourceView = self.view
//        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
//        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
        
        
    

    }
    
    @IBAction func previewFollowers(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "MyFollowersVC") as! MyFollowersVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func previewFollowings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "MyFollowingVC") as! MyFollowingVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func Logout()  {
        let def = UserDefaults.standard
        
        def.removeObject(forKey: "user_token")
        def.removeObject(forKey: "user_id")
        def.removeObject(forKey: "username")
        def.removeObject(forKey: "avatar")
        def.removeObject(forKey: "bgGallery")
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateInitialViewController()
        //  let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    func setupView() {
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        profileImageView.layer.masksToBounds = false
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        editinfoView.layer.cornerRadius = editinfoView.bounds.height / 2
        editinfoView.clipsToBounds = true
        
        settingsView.layer.cornerRadius = settingsView.bounds.height / 2
        settingsView.clipsToBounds = true
        
        userProfilefollowings.layer.borderWidth = 1
        userProfilefollowings.layer.masksToBounds = false
        userProfilefollowings.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        userProfilefollowings.layer.cornerRadius = 5.0
        userProfilefollowings.clipsToBounds = true
        
        userProfilefollowers.layer.borderWidth = 1
        userProfilefollowers.layer.masksToBounds = false
        userProfilefollowers.layer.borderColor = UIColor.red.cgColor
        userProfilefollowers.layer.cornerRadius = 5.0
        userProfilefollowers.clipsToBounds = true
        
        picView.layer.borderWidth = 1
        picView.layer.masksToBounds = false
        picView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        picView.layer.cornerRadius = 35.0
        picView.clipsToBounds = true
        picView.layer.shadowOffset = CGSize(width: 0, height: 3)
        picView.layer.shadowRadius = 1
        picView.layer.shadowColor = UIColor(hexString: "bfbdbd").cgColor
        
        goView.layer.cornerRadius = 10.0
        goView.clipsToBounds = true
        
    }
    
    // MARK: Func of all views in controller
    func beforChangeHappend() -> Void {
        contViewGallary.isHidden = true
        contViewAbout.isHidden = true
        galleryLabel.backgroundColor = UIColor.white
        aboutlabel.backgroundColor = UIColor.white
    }
}
