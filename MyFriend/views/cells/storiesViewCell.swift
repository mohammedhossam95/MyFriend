//
//  storiesViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/14/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia

class storiesVideoCell: UICollectionViewCell {
    

    @IBOutlet weak var stroyUserPhoto: UIImageView!
    @IBOutlet weak var storyUserName: UILabel!
    @IBOutlet weak var videoView: PlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stroyUserPhoto.layer.cornerRadius = stroyUserPhoto.bounds.height / 2
        stroyUserPhoto.clipsToBounds = true
        videoView.layer.cornerRadius = 10.0
        videoView.clipsToBounds = true
    }
    
    func configCell(story: HomePost) {
        guard let url = URL(string: URLs.photoMain + story.galleryFile) else {return}
        let avPlayer = AVPlayer(url: url)
        videoView?.playerLayer.player = avPlayer
        videoView.playerLayer.videoGravity = .resizeAspectFill
    }
    
    func configureCell(story: data) {
        guard let url = URL(string: URLs.photoMain + story.background) else {return}
        let avPlayer = AVPlayer(url: url)
        videoView?.playerLayer.player = avPlayer
        stroyUserPhoto.kf.indicatorType = .activity
        if let url = URL(string: URLs.photoMain + story.avatar){
            stroyUserPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        storyUserName.text = story.name

    }
    
}
