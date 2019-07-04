//
//  MyStoryCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia

class MyStoryCell: UICollectionViewCell {
    
    @IBOutlet weak var storyPhoto: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var viewsLbl: UILabel!
    var player: AVPlayer!
    var viewsBtn:  (()->())?
    var deleteBtn: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        viewsLbl.text = String(story.views)
    }
    
    @IBAction func previewViews(_ sender: UIButton) {
        viewsBtn?()
    }
    @IBAction func deleteStory(_ sender: UIButton) {
        deleteBtn?()
    }
}
