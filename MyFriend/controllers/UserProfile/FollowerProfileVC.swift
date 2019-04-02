//
//  FollowerProfileVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class FollowerProfileVC: BaseViewController {
    
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
    @IBOutlet weak var userProfileAge: UIButton!
    @IBOutlet weak var verifyImage: UIImageView!
    @IBOutlet weak var icChat_Img: UIImageView!
    @IBOutlet weak var icFollow_btn: UIImageView!
    @IBOutlet weak var userBio: UILabel!
    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var followLable: UILabel!
    @IBOutlet weak var aboutlabel: UILabel!
    @IBOutlet weak var galleryLabel: UILabel!
    
    var userId: Int = 0
    var UProfile = Profile()
    
    @IBAction func blockBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to Block ?", preferredStyle: .actionSheet)
        
        let Confirm = UIAlertAction(title: "Block", style: .destructive) { (action) in
            self.Block(friend_id: self.userId)
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel btn")
        }
        alertController.addAction(Confirm)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
        self.showSpecificLoading()
        self.showLoading()
        self.handleProfileRefresh(friend_id: userId)
        self.beforChangeHappend()
        
    }
    
    func handleProfileRefresh(friend_id: Int)  {
        ApiCalls.getUserProfile(friend_id: friend_id) { (error: Error?, profile: Profile?) in
            if let profile = profile{
                self.UProfile = profile
                self.updateUI(profile: self.UProfile)
            }else {
                self.hideSpecificLoading()
                self.hideLoading()
                let alertController = UIAlertController(title: "Confirm", message: "friend account not activated yet", preferredStyle: .alert)
                let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    _ = self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(cancelBtn)
                self.navigationController?.present(alertController, animated: true, completion: nil)

            }
        }
    }
    func updateUI(profile: Profile)  {
        
        self.profileImage.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(profile.avatar)")
        {
            self.profileImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        if profile.verified == 0 {
            verifyImage.isHidden = true
        }else {
            verifyImage.isHidden = false
        }
        
        
        if profile.privateAc == true && profile.caseSt == 3 {
            contViewGallary.isHidden = false
            galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        }else if profile.privateAc == true && profile.caseSt == 4 {
            self.beforChangeHappend()
        }else if profile.privateAc == true && profile.caseSt == 1 {
            self.beforChangeHappend()
        }else {
            self.beforChangeHappend()
            contViewGallary.isHidden = false
            galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        }
        
        
        //icRequested
        switch profile.caseSt {
        case 0:
            self.icFollow_btn.image = UIImage(named: "icfollow")
        case 1:
            self.icFollow_btn.image = UIImage(named: "icfollow")
            self.followLable.text = profile.case_name
        case 2:
            self.icFollow_btn.image = UIImage(named: "icRequested")
            self.followLable.text = profile.case_name
            self.beforChangeHappend()
        case 3:
            self.icFollow_btn.image = UIImage(named: "IcUUnFollow")
            self.followLable.text = profile.case_name
        case 4:
            self.icFollow_btn.image = UIImage(named: "icfollow")
            self.followLable.text = "\(profile.case_name)"
            //            contViewGallary.isHidden = false
            //            galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
            
        default:
            self.icFollow_btn.image = UIImage(named: "icunfollow")
        }
        self.userProfileName.text = profile.username
        self.userBio.text = profile.bio
        self.userProfilefollowers.setTitle("\(profile.followers) Followers", for: .normal)
        self.userProfileAge.setTitle("\(profile.following) Following", for: .normal)
        self.hideSpecificLoading()
        self.hideLoading()
    }
    
    @IBAction func previewGallery(_ sender: UIButton) {
        self.beforChangeHappend()
        galleryLabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        contViewGallary.isHidden = false
    }
    @IBAction func previewEditInfo(_ sender: UIButton) {
        self.showLoading()
        followAction(friend_id: self.userId, profile: self.UProfile)
    }
    @IBAction func previewSettings(_ sender: UIButton) {
        ChatAction(friend_id: self.userId, profile: self.UProfile)
    }
    
    
    //control follow status
    func followAction(friend_id: Int,profile: Profile) {
        if profile.case_name == "Follow" || profile.caseSt == 1{
            ApiCalls.sendfollow(friend_id: friend_id) { (error: Error?, success: Bool, status: String) in
                if success {
                    self.hideLoading()
                    self.handleProfileRefresh(friend_id: self.userId)
                }else {
                    self.hideLoading()
                    self.showAlertError(title: status)
                    //print(error?.localizedDescription as Any)
                }
            }
        }else if profile.case_name == "Requested" || profile.caseSt == 2{
            print("Requested")
            self.hideLoading()
            let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel ?", preferredStyle: .actionSheet)
            
            let Confirm = UIAlertAction(title: "Cancel Request", style: .destructive) { (action) in
                self.unfollow(friend_id: friend_id)
            }
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(Confirm)
            alertController.addAction(cancelBtn)
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)

        }else if profile.case_name == "unFollow" || profile.caseSt == 3{
            print("unfollow")
            self.hideLoading()
            let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel ?", preferredStyle: .actionSheet)
            
            let Confirm = UIAlertAction(title: "\(profile.case_name)", style: .destructive) { (action) in
                self.unfollow(friend_id: friend_id)
            }
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(Confirm)
            alertController.addAction(cancelBtn)
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }else if profile.case_name == "Follow back" || profile.caseSt == 4{
            print("Follow back")
            ApiCalls.sendFollowback(friend_id: friend_id) { (error: Error?, success: Bool, status: String) in
                if success {
                    self.hideLoading()
                    self.handleProfileRefresh(friend_id: self.userId)
                }else {
                    self.hideLoading()
                    self.showAlertError(title: status)
                    //print(error?.localizedDescription as Any)
                }
            }
        }else{
            print("action error")
        }
    }
    
    ///Control chat Action to open Chat
    
    func ChatAction(friend_id: Int,profile: Profile) {
        if profile.case_name == "Follow" || profile.caseSt == 1{
            let alertController = UIAlertController(title: profile.case_name, message: "You should Follow this person", preferredStyle: .actionSheet)
            let Confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alertController.addAction(Confirm)
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }else if profile.case_name == "Requested" || profile.caseSt == 2{
            print("Requested")
            self.hideLoading()
            let alertController = UIAlertController(title: "Confirm", message: "\(profile.username) should accept your Request First", preferredStyle: .alert)
            
            let Confirm = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }

            alertController.addAction(Confirm)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }else if profile.case_name == "unFollow" || profile.caseSt == 3{
            openChatRoomVC(friend_id: friend_id, profile: self.UProfile)
        }else if profile.case_name == "Follow back" || profile.caseSt == 4{
            
            let alertController = UIAlertController(title: profile.case_name, message: "You should Follow this person", preferredStyle: .alert)
            let Confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alertController.addAction(Confirm)
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }else{
            print("action error")
        }
    }
    
    func openChatRoomVC(friend_id: Int, profile: Profile) {
        
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        SB.userNameTxt = profile.username
        SB.profileImage = profile.avatar
        SB.frindID = friend_id
 
        self.navigationController?.present(SB, animated: true, completion: nil)
        
    }
    
    @IBAction func previewFollowers(_ sender: UIButton) {
        print("followers")
//        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
//        let VC = storyboard.instantiateViewController(withIdentifier: "MyFollowersVC") as! MyFollowersVC
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func previewFollowings(_ sender: UIButton) {
        print("followers")
//        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
//        let VC = storyboard.instantiateViewController(withIdentifier: "MyFollowingVC") as! MyFollowingVC
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func previewAbout(_ sender: UIButton) {
        self.beforChangeHappend()
        aboutlabel.backgroundColor = UIColor.init(hexString: "f92d2d")
        contViewAbout.isHidden = false
    }
    @IBAction func back(_ sender: UIButton) {
        // self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
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
        
        userProfileAge.layer.borderWidth = 1
        userProfileAge.layer.masksToBounds = false
        userProfileAge.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        userProfileAge.layer.cornerRadius = 5.0
        userProfileAge.clipsToBounds = true
        
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
        
        goView.layer.cornerRadius = 15.0
        goView.clipsToBounds = true
        
    }
    
    // MARK: Func of all views in controller
    func beforChangeHappend() -> Void {
        contViewGallary.isHidden = true
        contViewAbout.isHidden = true
        galleryLabel.backgroundColor = UIColor.white
        aboutlabel.backgroundColor = UIColor.white
    }
    func unfollow(friend_id: Int) {
        ApiCalls.sendRequested(friend_id: friend_id) { (error: Error?, success: Bool, status: String) in
            if success {
                self.hideLoading()
                self.handleProfileRefresh(friend_id: self.userId)
            }else {
                self.hideLoading()
                self.showAlertError(title: status)
                //print(error?.localizedDescription as Any)
            }
        }
    }

    func Block(friend_id: Int) {
        ApiCalls.sendBlock(friend_id: friend_id) { (error: Error?, success: Bool, status: String) in
            if success {
                self.hideLoading()
                let alertController = UIAlertController(title: "", message: "User Blocked successfully ?", preferredStyle: .alert)
                

                let cancelBtn = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    print("Cancel btn")
                }

                alertController.addAction(cancelBtn)
                
                self.navigationController?.present(alertController, animated: true, completion: nil)

                self.handleProfileRefresh(friend_id: self.userId)
            }else {
                self.hideLoading()
                self.showAlertError(title: "status")
                //print(error?.localizedDescription as Any)
            }
        }
    }
}
