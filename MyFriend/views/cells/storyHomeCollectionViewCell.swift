//
//  storyHomeCollectionViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia


class storyHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storyPhoto: UIImageView!
    @IBOutlet weak var stroyUserPhoto: UIImageView!
    @IBOutlet weak var storyUserName: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    var player: AVPlayer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stroyUserPhoto.layer.cornerRadius = stroyUserPhoto.bounds.height / 2
        stroyUserPhoto.clipsToBounds = true
        storyPhoto.layer.cornerRadius = 10.0
        storyPhoto.clipsToBounds = true
        videoView.layer.cornerRadius = 10.0
        videoView.clipsToBounds = true
    }
    
    func configCell(story: HomePost) {
        if story.type == "video"{
            
            self.storyPhoto.isHidden = true
            self.videoView.isHidden = false
            
            guard let url = URL(string: URLs.photoMain + story.galleryFile) else {return}
            self.player = AVPlayer(url: url)
            
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = videoView.bounds
            videoLayer.videoGravity = .resizeAspectFill
            self.videoView.layer.addSublayer(videoLayer)
            
            self.player.play()
            self.player.isMuted = true
        }else{
            self.storyPhoto.isHidden = false
            self.videoView.isHidden = true
            storyPhoto.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + story.galleryFile){
                storyPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }
       
    }
    
    func configureCell(story: data) {
        if story.background_type == "video"{
            
            self.storyPhoto.isHidden = true
            self.videoView.isHidden = false
            
            guard let url = URL(string: URLs.photoMain + story.background) else {return}
            self.player = AVPlayer(url: url)
            
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = videoView.bounds
            videoLayer.videoGravity = .resizeAspectFill
            self.videoView.layer.addSublayer(videoLayer)
            
            self.player.play()
            self.player.isMuted = true
        }else{
            self.storyPhoto.isHidden = false
            self.videoView.isHidden = true
            storyPhoto.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + story.background){
                storyPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }
        
        stroyUserPhoto.kf.indicatorType = .activity
        if let url = URL(string: URLs.photoMain + story.avatar){
            stroyUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        storyUserName.text = story.name
    }

}
//Mark :- Add Story Cell
class addStoryCell: UICollectionViewCell {
    @IBOutlet weak var storyPhoto: UIImageView!
    @IBOutlet weak var stroyUserPhoto: UIImageView!
    @IBOutlet weak var storyUserName: UILabel!
    @IBOutlet weak var stroyUserPhotoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stroyUserPhotoView.layer.cornerRadius = stroyUserPhotoView.bounds.height / 2
        stroyUserPhotoView.clipsToBounds = true
        storyPhoto.layer.cornerRadius = 10.0
        storyPhoto.clipsToBounds = true
    }
    
    func configureCell() {
        guard let user_avatar = helper.getUserAvatar() else {return}
        storyPhoto.kf.indicatorType = .activity
        if let url = URL(string: URLs.photoMain + user_avatar){
            storyPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        storyUserName.text = "Add Story"
    }
}

