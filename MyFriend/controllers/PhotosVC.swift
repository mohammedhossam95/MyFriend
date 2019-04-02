//
//  PhotosVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/13/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia

class PhotosVC: BaseViewController {
    
    @IBOutlet weak var numphotoLove: UILabel!
    @IBOutlet weak var numphotoKiss: UILabel!
    @IBOutlet weak var numphotoWow: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imoLove: UIImageView!
    @IBOutlet weak var imoKiss: UIImageView!
    @IBOutlet weak var imoWow: UIImageView!
    @IBOutlet weak var numofViews: UILabel!
    @IBOutlet weak var numofComments: UILabel!
    
    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    var gallery_id: Int = 0
    var singleGallery = SingleGallery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabgetsure: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.photo.addGestureRecognizer(tabgetsure)
        let pinshgetsure: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zooming))
        self.photo.addGestureRecognizer(pinshgetsure)
        
        self.showLoading()
        self.photo.isUserInteractionEnabled = true
        self.ShowSingleGallery(gallery_id: gallery_id)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getEmojiPostsSockets(completionHandler: { (homePost: HomePost) in
            DispatchQueue.main.async {
                self.numphotoLove.text = String(homePost.liked)
                self.numphotoKiss.text = String(homePost.love)
                self.numphotoWow.text = String(homePost.wow)
            }
        })
    }

    func ShowSingleGallery(gallery_id: Int)  {
        ApiCalls.getSinglePhoto(gallery_id: gallery_id) { (error: Error?, singleGallery: SingleGallery?) in
            if let singleGallery = singleGallery{
                self.singleGallery = singleGallery
                self.update(post: self.singleGallery)
            }
        }
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
    @objc func tableViewTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc func zooming(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
    func update(post: SingleGallery) {
        print(post)
        
        if post.hasLiked == "false" {
            self.imoLove.image = UIImage(named: "imoLove")
            self.numphotoLove.textColor = UIColor.white
        }else{
            self.imoLove.image = UIImage(named: "loveC")
            self.numphotoKiss.textColor = UIColor.red
        }
        
        if post.hasLoved == "false" {
            self.imoKiss.image = UIImage(named: "imoKiss")
            self.numphotoKiss.textColor = UIColor.white
        }else{
            self.imoKiss.image = UIImage(named: "kissC")
            self.numphotoKiss.textColor = UIColor.red
        }
        
        if post.hasWowed == "false" {
            self.imoWow.image = UIImage(named: "imoWow")
            self.numphotoWow.textColor = UIColor.white
        }else{
            self.imoWow.image = UIImage(named: "wowC")
            self.numphotoWow.textColor = UIColor.red
        }
        
        numphotoLove.text   = String(post.liked)
        numphotoKiss.text   = String(post.love)
        numphotoWow.text    = String(post.wow)
        numofViews.text     = "\(post.viewersCount) Views"
        numofComments.text  = "\(post.totalComments) Comments"
        
        photo.isHidden = false
        videoView.isHidden = true
        photo.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(post.file)"){
            self.hideLoading()
            photo.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        self.hideLoading()
    }
    
    @IBAction func Close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openViews(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "ViewsVC") as! ViewsVC
        SB.id = singleGallery.galleryId
        self.present(SB, animated: true, completion: nil)
    }
    
    @IBAction func openComments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        SB.id = singleGallery.galleryId
        self.present(SB, animated: true, completion: nil)
    }
    
    @IBAction func loveBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if self.numphotoLove.textColor == UIColor.red {
            imoLove.image = UIImage(named: "imoLove")
            numphotoLove.textColor = UIColor.black
        }else{
            imoLove.image = UIImage(named: "loveC")
            numphotoLove.textColor = UIColor.red
        }
        numphotoKiss.textColor = UIColor.white
        imoKiss.image = UIImage(named: "imoKiss")
        numphotoWow.textColor = UIColor.white
        imoWow.image = UIImage(named: "imoWow")
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: singleGallery.galleryId, emojiType: "liked")
    }
    
    @IBAction func kissBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if numphotoKiss.textColor == UIColor.red {
            imoKiss.image = UIImage(named: "imoKiss")
            numphotoKiss.textColor = UIColor.white
        }else{
            imoKiss.image = UIImage(named: "kissC")
            numphotoKiss.textColor = UIColor.red
        }
        numphotoLove.textColor = UIColor.white
        imoLove.image = UIImage(named: "imoLove")
        numphotoWow.textColor = UIColor.white
        imoWow.image = UIImage(named: "imoWow")
        
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: singleGallery.galleryId, emojiType: "love")
    }
    
    @IBAction func wowBtn(_ sender: UIButton) {
        
        let userID = helper.getUserId()
        if numphotoWow.textColor == UIColor.red {
            numphotoWow.textColor = UIColor.white
            imoWow.image = UIImage(named: "imoWow")
        }else{
            imoWow.image = UIImage(named: "wowC")
            numphotoWow.textColor = UIColor.red
        }
        numphotoLove.textColor = UIColor.white
        imoLove.image = UIImage(named: "imoLove")
        numphotoKiss.textColor = UIColor.white
        imoKiss.image = UIImage(named: "imoKiss")
        
        SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: singleGallery.galleryId, emojiType: "wow")
    }
}
