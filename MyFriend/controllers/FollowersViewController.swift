//
//  FollowersViewController.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import Koloda
import GoogleMobileAds

class FollowersViewController: BaseViewController, GADInterstitialDelegate  {
    
    @IBOutlet weak var sview: UIView!
    @IBOutlet weak var nobeView: UIView!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var TinderView: KolodaView!
    
    var followers:[Follower] = [Follower]()
    var isLoading = false
    
    var current_page = 1
    var last_page = 1
    var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        self.showLoading()
        self.handleRefresh()
        
        self.TinderView.dataSource = self
        self.TinderView.delegate = self
        
        self.setup()
        // Do any additional setup after loading the view.
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    func setup() {
        nobeView.layer.borderWidth = 1
        nobeView.layer.masksToBounds = false
        nobeView.layer.borderColor = UIColor.white.cgColor
        nobeView.layer.cornerRadius = nobeView.bounds.height / 2
        nobeView.clipsToBounds = true
        
        followView.layer.borderWidth = 1
        followView.layer.masksToBounds = false
        followView.layer.borderColor = UIColor.white.cgColor
        followView.layer.cornerRadius = followView.bounds.height / 2
        followView.clipsToBounds = true
        
    }
    @IBAction func followBtn(_ sender: UIButton) {
        print(TinderView.currentCardIndex)
        print(followers.count)
        if TinderView.currentCardIndex >= followers.count || TinderView.currentCardIndex < 0{
            let alertController = UIAlertController(title: "", message: "There is no Users to follow ", preferredStyle: .alert)
            let Confirm = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
            alertController.addAction(Confirm)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }else {
            let x = self.followers[TinderView.currentCardIndex]
            print("user id")
            print(x.userId)
            
            ApiCalls.sendfollow(friend_id: x.userId) { (error: Error?, success: Bool, status: String) in
                if success {
                    self.hideLoading()
                    
                    self.TinderView.swipe(SwipeResultDirection.right)
                    //.self.showAlertsuccess(title: status)
                }else {
                    self.hideLoading()
                    self.showAlertError(title: status)
                    //print(error?.localizedDescription as Any)
                }
            }
        }
    }
    @IBAction func UnfollowBtn(_ sender: UIButton) {
        self.showLoading()
        if TinderView.currentCardIndex >= followers.count || TinderView.currentCardIndex < 0{
            let alertController = UIAlertController(title: "", message: "There is no Users to Nope ", preferredStyle: .alert)
            let Confirm = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
            alertController.addAction(Confirm)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }else {
            if TinderView.currentCardIndex > -1 {
                let x = self.followers[TinderView.currentCardIndex]
                print(x.userId)
                ApiCalls.block(friend_id: x.userId) { (error: Error?, status: String, success: Bool) in
                    if success {
                        self.hideLoading()
                        
                        self.TinderView.swipe(SwipeResultDirection.left)
                        //.self.showAlertsuccess(title: status)
                    }else {
                        self.hideLoading()
                        self.showAlertError(title: status)
                        //print(error?.localizedDescription as Any)
                    }
                }
            }else {
                TinderView.reloadData()
            }
            
        }
    }
    
    @objc func handleRefresh()  {
        //  self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getfolloewrs { (error: Error?, followers: [Follower]?, last_page: Int) in
            if let followers = followers{
                self.followers = followers
                // print(followers)
                if followers.count != 0{
                    self.hideLoading()
                    self.TinderView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page
                }else{
                    self.hideLoading()
                    print("No Data")
                    self.nobeView.isHidden = true
                    self.followView.isHidden = true
                    
                }
                
            }
        }
    }
    
    // MARK: - Help methods
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1940793456791298/4803613580")
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
extension FollowersViewController: KolodaViewDelegate, KolodaViewDataSource{
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let c = TinderCard()
        if let x: Follower = self.followers[index] {
            c.configureCell(viewModelCard: x)
        }
        return c
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.followers.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
        VC.userId = self.followers[index].userId
        UserAboutTableVC.userId = self.followers[index].userId
        userGallaryVC.id = self.followers[index].userId
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("kolodaDidRunOutOfCards")
        handleRefresh()
        koloda.reloadData()
        TinderView.reloadData()
    }
}
