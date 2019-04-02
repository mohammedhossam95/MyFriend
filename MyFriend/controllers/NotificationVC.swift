//
//  NotificationVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/11/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import GoogleMobileAds

class NotificationVC: BaseViewController {
    
    @IBOutlet weak var notificationTable: UITableView!
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = URLs.bannarId
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleNotificationRefresh), for: .valueChanged)
        return refresher
    }()
    
    var NotificationsArr = [Notification]()
    var isLoading = false
    var current_page = 1
    var last_page = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        notificationTable.tableFooterView = UIView()
        notificationTable.addSubview(refresher)
        handleNotificationRefresh()
        adBannerView.load(GADRequest())
        // Do any additional setup after loading the view.
    }
    
    @objc func handleNotificationRefresh()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getnotifications { (error: Error?, Notifications: [Notification]?, last_page: Int) in
            self.isLoading = false
            if let Notifications = Notifications{
                self.hideLoading()
                self.NotificationsArr = Notifications
                self.notificationTable.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
        
    }
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        
        ApiCalls.getnotifications(page: current_page+1) { (error: Error?, Notifications: [Notification]?, last_page: Int) in
            self.isLoading = false
            if let posts = Notifications{
                //self.tablePosts = posts
                self.NotificationsArr.append(contentsOf: posts)
                self.notificationTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                
            }
        }
    }
    
    func openProfileFromHome(Id:Int) {
        let userID = helper.getUserId()
        
        if userID == Id {
            let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
            VC.userId = Id
            userAboutVC.userId = Id
            userGallaryVC.id = Id
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}

extension NotificationVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.NotificationsArr.count
        if indexPath.row == count-1 {
            self.LoadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let NotificationType = NotificationsArr[indexPath.row].type
        switch NotificationType {
        case 0:
            
            let cell = self.notificationTable.dequeueReusableCell(withIdentifier: "SimpleNotificationCell", for: indexPath) as! SimpleNotificationCell
            cell.selectionStyle = .none
            cell.notificationUserPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].avatar)")
            {
                cell.notificationUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            cell.notificationTypeImage.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].icons)"){
                cell.notificationTypeImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            cell.openProfile = {
                self.openProfileFromHome(Id: self.NotificationsArr[indexPath.row].userId)
                
            }
            cell.notificationUserName.text = NotificationsArr[indexPath.row].name
            cell.notificationText.text = NotificationsArr[indexPath.row].text
            cell.notificationUserTime.text = NotificationsArr[indexPath.row].time
            return cell
            
        case 1:
            
            let cell = self.notificationTable.dequeueReusableCell(withIdentifier: "TwoButtonsNotificationCell", for: indexPath) as! TwoButtonsNotificationCell
            cell.selectionStyle = .none
            cell.type3NotificationUserPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].avatar)"){
                cell.type3NotificationUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            
            cell.type3NotificationTypeImage.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + NotificationsArr[indexPath.row].icons){
                
                cell.type3NotificationTypeImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            cell.confirmBtn = {
                self.showLoading()
                ApiCalls.sendConfirm(friend_id: self.NotificationsArr[indexPath.row].userId) { (error: Error?, success: Bool, status: String) in
                    if success {
                        self.hideLoading()
                        print("succes")
                        //.self.showAlertsuccess(title: status)
                    }else {
                        self.hideLoading()
                        self.showAlertError(title: status)
                        //print(error?.localizedDescription as Any)
                    }
                }
                
            }
            cell.rejectBtn = {
                self.showLoading()
                ApiCalls.sendReject(friend_id: self.NotificationsArr[indexPath.row].userId) { (error: Error?, success: Bool, status: String) in
                    if success {
                        self.hideLoading()
                        print("succes")
                        //.self.showAlertsuccess(title: status)
                    }else {
                        self.hideLoading()
                        self.showAlertError(title: status)
                        //print(error?.localizedDescription as Any)
                    }
                }
            }
            cell.openProfile = {
                self.openProfileFromHome(Id: self.NotificationsArr[indexPath.row].userId)
                
            }
            cell.type3NotificationUserName.text  = NotificationsArr[indexPath.row].name
            cell.type3NotificationUserTime.text  = NotificationsArr[indexPath.row].date
            cell.type3NotificationText.text = NotificationsArr[indexPath.row].text
            return cell
            
        case 2:
            let cell = self.notificationTable.dequeueReusableCell(withIdentifier: "TwoImagesNotificationCell", for: indexPath) as! TwoImagesNotificationCell
            cell.selectionStyle = .none
            if NotificationsArr[indexPath.row].mimo_type == "video"{
                cell.type2Image.isHidden = false
                cell.type2Image.image = UIImage(named: "video")
                
            }else {
                cell.type2Image.isHidden = false
                cell.type2Image.kf.indicatorType = .activity
                if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].reference)") {
                    cell.type2Image.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
            }
            cell.type2NotificationTypeImage.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].icons)") {
                cell.type2NotificationTypeImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            
            cell.type2NotificationUserPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].avatar)") {
                cell.type2NotificationUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            
            cell.openProfile = {
                self.openProfileFromHome(Id: self.NotificationsArr[indexPath.row].userId)
            }
            cell.openImage = {
                if self.NotificationsArr[indexPath.row].text != "add new story"{
                    if self.NotificationsArr[indexPath.row].mimo_type == "video"{
                        if let url = URL(string: "\(URLs.photoMain)\(self.NotificationsArr[indexPath.row].reference)"){
                            let video = AVPlayer(url: url)
                            let videoPlayer = AVPlayerViewController()
                            videoPlayer.player = video
                            self.present(videoPlayer, animated: true, completion: {
                                video.play()
                            })
                        }
                    }else{
                        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
                        VC.gallery_id = self.NotificationsArr[indexPath.row].reference_id
                        self.navigationController?.present(VC, animated: true, completion: nil)
                    }
                    
                }
            }
            cell.type2NotificationUserName.text = NotificationsArr[indexPath.row].name
            cell.type2NotiificationText.text = NotificationsArr[indexPath.row].text
            cell.type2NotificationUserTime.text = NotificationsArr[indexPath.row].date
            
            return cell
            
        case 3:
            
            let cell = self.notificationTable.dequeueReusableCell(withIdentifier: "TwoImagesNotificationCell", for: indexPath) as! TwoImagesNotificationCell
            
            cell.selectionStyle = .none
            if NotificationsArr[indexPath.row].mimo_type == "video"{
                cell.type2Image.isHidden = true
            }else {
                cell.type2Image.isHidden = false
                cell.type2Image.kf.indicatorType = .activity
                if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].reference)") {
                    cell.type2Image.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
            }
            cell.type2NotificationTypeImage.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].icons)") {
                cell.type2NotificationTypeImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            
            cell.type2NotificationUserPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(NotificationsArr[indexPath.row].avatar)") {
                cell.type2NotificationUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }

            cell.openProfile = {
                self.openProfileFromHome(Id: self.NotificationsArr[indexPath.row].userId)
            }
            
            cell.openImage = {
                if self.NotificationsArr[indexPath.row].text != "add new story"{
                }
            }
            
            cell.type2NotificationUserName.text = NotificationsArr[indexPath.row].name
            cell.type2NotiificationText.text = NotificationsArr[indexPath.row].text
            cell.type2NotificationUserTime.text = NotificationsArr[indexPath.row].date
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}

extension NotificationVC : GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.notificationTable.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.notificationTable.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}
