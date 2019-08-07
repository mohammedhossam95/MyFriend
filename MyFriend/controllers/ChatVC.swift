//
//  ViewController.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/6/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds

class ChatVC: BaseViewController {
    
    @IBOutlet weak var listUserChatsTable: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = URLs.bannarId
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var unreadMessages = [unReadMessage]()
    var isLoading = false
    var current_page = 1
    var last_page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listUserChatsTable.addSubview(refresher)
        adBannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showLoading()
        self.handleRefresh()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    @objc func handleRefresh()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.listUserChats { (error: Error?, unReadMessages: [unReadMessage]?, last_page: Int) in
            self.isLoading = false
            self.unreadMessages.removeAll()
            if let unReadMessages = unReadMessages{
                self.unreadMessages = unReadMessages
                self.listUserChatsTable.reloadData()
                self.hideLoading()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        
        ApiCalls.listUserChats(page: current_page+1) { (error: Error?, unReadMessages: [unReadMessage]?, last_page: Int) in
            self.isLoading = false
            if let unReadMessages = unReadMessages{
                self.unreadMessages.append(contentsOf: unReadMessages)
                self.listUserChatsTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                
            }
        }
    }
    
    // Mark:- handle table click Methods "did select row at index path"
    func openChatRoomVC(unReadMessage: unReadMessage) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        SB.userNameTxt = unReadMessage.name
        SB.profileImage = unReadMessage.avatar
        SB.frindID = unReadMessage.user_id
        self.navigationController?.present(SB, animated: true, completion: nil)
    }
    
    func openProfileFromHome(Id:Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
        VC.userId = Id
        UserAboutTableVC.userId = Id
        userGallaryVC.id = Id
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
extension ChatVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.unreadMessages.count
        if indexPath.row == count-1 {
            self.LoadMore()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return unreadMessages.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return adBannerView.frame.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.selectionStyle = .none
        
        if unreadMessages[indexPath.row].count_unread_msg > 0{
            cell.count_unread_msgView.isHidden = false
            cell.count_unread_msg.isHidden = false
            cell.count_unread_msg.text = String(unreadMessages[indexPath.row].count_unread_msg)
            cell.count_unread_msg.textColor = UIColor.white
            cell.count_unread_msgView.backgroundColor = UIColor(hexString: "f92d2d")
            cell.snderName.textColor = UIColor(hexString: "f92d2d")
            cell.snderName.text = unreadMessages[indexPath.row].name
            cell.lastMessage.text = unreadMessages[indexPath.row].last_message
            cell.messageTime.text = unreadMessages[indexPath.row].created_at
            
            cell.senderPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(unreadMessages[indexPath.row].avatar)")
            {
                cell.senderPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }else{
            cell.snderName.text = unreadMessages[indexPath.row].name
            cell.lastMessage.text = unreadMessages[indexPath.row].last_message
            cell.messageTime.text = unreadMessages[indexPath.row].created_at
            
            cell.senderPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(unreadMessages[indexPath.row].avatar)")
            {
                cell.senderPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            cell.count_unread_msgView.isHidden = true
            cell.count_unread_msg.isHidden = true
            cell.snderName.textColor = UIColor.black
        }
        
        cell.profileBtn = {
            self.openProfileFromHome(Id: self.unreadMessages[indexPath.row].user_id)
        }
        cell.chatBtn = {
            self.openChatRoomVC(unReadMessage: self.unreadMessages[indexPath.row])
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension ChatVC : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
