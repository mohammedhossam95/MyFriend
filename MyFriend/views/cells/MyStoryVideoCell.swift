//
//  MyStoryVideoCell.swift
//  MyFriend
//
//  Created by hossam Adawi on 2/18/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import AVFoundation

class MyStoryVideoCell: UICollectionViewCell {

    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var viewsLbl: UILabel!
    
    var viewsBtn:  (()->())?
    var deleteBtn: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoView.layer.cornerRadius = 10.0
        videoView.clipsToBounds = true
    }
    
    func configCell(story: HomePost) {
        
        guard let url = URL(string: URLs.photoMain + story.galleryFile) else {return}
        let avPlayer = AVPlayer(url: url)
        videoView?.playerLayer.player = avPlayer
        videoView.playerLayer.videoGravity = .resizeAspectFill
        
        viewsLbl.text = String(story.views)
    }
    
    @IBAction func previewViews(_ sender: UIButton) {
        viewsBtn?()
    }
    @IBAction func deleteStory(_ sender: UIButton) {
        deleteBtn?()
    }
}
