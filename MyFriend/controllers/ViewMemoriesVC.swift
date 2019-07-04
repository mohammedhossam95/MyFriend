//
//  ViewMemoriesVC.swift
//  MyFriend
//
//  Created by Mohammed Hossam on 2/10/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia

class ViewMemoriesVC: BaseViewController {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var StoryTime: UILabel!
    @IBOutlet weak var storyPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var storyText: UILabel!
    @IBOutlet weak var imoLove: UIImageView!
    @IBOutlet weak var imoKiss: UIImageView!
    @IBOutlet weak var imoWow: UIImageView!
    @IBOutlet weak var numofViews: UILabel!
    @IBOutlet weak var numofComments: UILabel!
    @IBOutlet weak var numphotoLove: UILabel!
    @IBOutlet weak var numphotoKiss: UILabel!
    @IBOutlet weak var numphotoWow: UILabel!
    
    var post = HomePost()
    
    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pinshgetsure: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zooming))
        self.storyPhoto.addGestureRecognizer(pinshgetsure)
        
        setupView()
        self.showLoading()
        self.storyPhoto.isUserInteractionEnabled = true
        update(post: post)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    // MARK: Actions
    @objc func zooming(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
    func update(post: HomePost) {

        
        if post.hasLiked == "false" {
            self.imoLove.image = UIImage(named: "imoLove")
            self.numphotoLove.textColor = UIColor.lightGray
        }else{
            self.imoLove.image = UIImage(named: "loveC")
            self.numphotoKiss.textColor = UIColor.red
        }
        
        if post.hasLoved == "false" {
            self.imoKiss.image = UIImage(named: "imoKiss")
            self.numphotoKiss.textColor = UIColor.lightGray
        }else{
            self.imoKiss.image = UIImage(named: "kissC")
            self.numphotoKiss.textColor = UIColor.red
        }
        
        if post.hasWowed == "false" {
            self.imoWow.image = UIImage(named: "imoWow")
            self.numphotoWow.textColor = UIColor.lightGray
        }else{
            self.imoWow.image = UIImage(named: "wowC")
            self.numphotoWow.textColor = UIColor.red
        }
        
        numphotoLove.text   = String(post.liked)
        numphotoKiss.text   = String(post.love)
        numphotoWow.text    = String(post.wow)
        numofViews.text     = "\(post.views) Views"
        numofComments.text  = "\(post.comments) Comments"
        
        
        userName.text = post.name
        StoryTime.text = post.time
        storyText.text = post.text
            storyPhoto.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(post.galleryFile)"){
                self.hideLoading()
                storyPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        userPhoto.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(post.avatar)"){
            self.hideLoading()
            userPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        self.hideLoading()
    }
    @IBAction func Close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openViews(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "ViewsVC") as! ViewsVC
        SB.id = post.id
        self.present(SB, animated: true, completion: nil)
    }
    
    @IBAction func openComments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        SB.id = post.id
        self.present(SB, animated: true, completion: nil)
    }
    
    @IBAction func loveBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if self.numphotoLove.textColor == UIColor.red {
            imoLove.image = UIImage(named: "imoLove")
            numphotoLove.textColor = UIColor.lightGray
        }else{
            imoLove.image = UIImage(named: "loveC")
            numphotoLove.textColor = UIColor.red
        }
        numphotoKiss.textColor = UIColor.lightGray
        imoKiss.image = UIImage(named: "imoKiss")
        numphotoWow.textColor = UIColor.lightGray
        imoWow.image = UIImage(named: "imoWow")
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: post.id, emojiType: "liked")
    }
    
    @IBAction func kissBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if numphotoKiss.textColor == UIColor.red {
            imoKiss.image = UIImage(named: "imoKiss")
            numphotoKiss.textColor = UIColor.lightGray
        }else{
            imoKiss.image = UIImage(named: "kissC")
            numphotoKiss.textColor = UIColor.red
        }
        numphotoLove.textColor = UIColor.lightGray
        imoLove.image = UIImage(named: "imoLove")
        numphotoWow.textColor = UIColor.lightGray
        imoWow.image = UIImage(named: "imoWow")
        
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: post.id, emojiType: "love")
    }
    
    @IBAction func wowBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if numphotoWow.textColor == UIColor.red {
            numphotoWow.textColor = UIColor.lightGray
            imoWow.image = UIImage(named: "imoWow")
        }else{
            imoWow.image = UIImage(named: "wowC")
            numphotoWow.textColor = UIColor.red
        }
        numphotoLove.textColor = UIColor.lightGray
        imoLove.image = UIImage(named: "imoLove")
        numphotoKiss.textColor = UIColor.lightGray
        imoKiss.image = UIImage(named: "imoKiss")
        
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: post.id, emojiType: "wow")
    }
    
    func setupView(){
        userPhoto.layer.cornerRadius = userPhoto.bounds.height / 2
        userPhoto.clipsToBounds = true
        
    }
}
