//
//  FollowersVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/19/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Koloda

protocol FolowersView {
    func reloadKoloda()->()
    
}


class FollowersVC: BaseViewController {
    
    @IBOutlet weak var nobeView: UIView!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var kolodaView: KolodaView!
    
    var followers:[Follower] = [Follower]()
    var isLoading = false
    
    var current_page = 1
    var last_page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.handleRefresh()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        nobeView.layer.borderWidth = 1
        nobeView.layer.masksToBounds = false
        nobeView.layer.borderColor = UIColor.black.cgColor
        nobeView.layer.cornerRadius = nobeView.bounds.height / 2
        nobeView.clipsToBounds = true
        
        followView.layer.borderWidth = 1
        followView.layer.masksToBounds = false
        followView.layer.borderColor = UIColor.black.cgColor
        followView.layer.cornerRadius = followView.bounds.height / 2
        followView.clipsToBounds = true
    }
    
    @objc func handleRefresh()  {
      //  self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getfolloewrs { (error: Error?, followers: [Follower]?, last_page: Int) in
            if let followers = followers{
                self.followers = followers
               // print(followers)
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
}
extension FollowersVC: FolowersView{
    func reloadKoloda() {
        self.kolodaView.reloadData()
    }
}
// MARK: - KolodaViewDataSource

extension FollowersVC :KolodaViewDataSource {
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let c = TinderCard()
//        if let x: Follower = self.followers[index]{
            print(index)
            c.configureCell(viewModelCard: self.followers[index])
          //  c.configureCellTimer(viewModelCard: x)
     //   }
        return c
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.followers.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed.moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

// MARK: - KolodaViewDelegate

extension FollowersVC : KolodaViewDelegate {
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("kolodaDidRunOutOfCards")
        self.followers = []
        self.handleRefresh()
      //  self.viewModel.getCards(selectedMarket_id, 19, completion: { [weak self] (viewModelCards) in
       //     self?.cards = viewModelCards
     //   })
        koloda.reloadData()
        self.kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
     //   vc.card_id = self.followers[index].deployId!
        self.present(vc, animated: true, completion: nil)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .left { // Dis
            Musical.shared.playSound(0)
            
            var next_deploy_id = -1
            if !(kolodaView.currentCardIndex == self.followers.count) {
                next_deploy_id = self.followers[kolodaView.currentCardIndex].userId
                print(next_deploy_id)
            }
//            self.viewModel.dislikeCard(market_id: selectedMarket_id, deploy_id: self.cards[kolodaView.currentCardIndex-1].deployId!, next_deploy_id: next_deploy_id) {[unowned self] (status) in
//                switch status {
//                case true:
//                    print("DisLike sucess")
//                case false:
//                    print("DisLike failure")
//                }
//            }
        }
        else if direction == .right { // Like
            //Musical.shared.playSound(1)
            
            var next_deploy_id = -1
            if !(kolodaView.currentCardIndex == self.followers.count) {
                next_deploy_id = self.followers[kolodaView.currentCardIndex].userId
                print(next_deploy_id)
            }
            
//            self.viewModel.likeCard(market_id: selectedMarket_id, deploy_id: self.cards[kolodaView.currentCardIndex-1].deployId!, next_deploy_id: next_deploy_id) {[unowned self]  (result) in
//                switch result {
//                case 0:
//                    print("Max Likes")
//                    self.kolodaView?.revertAction()
//                case 1:
//                    print("Like success")
//                case 2:
//                    print("DisLike failure")
//                default:
//                    break
//                }
//            }
        }
    }
    
    
}




/*
extension FollowersVC: KolodaViewDataSource{
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: UIImage(named: followers[index].background))
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
       return followers.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    
}
extension FollowersVC: KolodaViewDelegate{
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
}
*/
