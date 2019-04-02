//
//  postsCellTableViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class postsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewsView: UIView!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var PostVideo: UIView!
    @IBOutlet weak var postNumOfLikes: UILabel!
    @IBOutlet weak var postNumOfKiss: UILabel!
    @IBOutlet weak var postNumOfWows: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var postNumOfViews: UILabel!
    @IBOutlet weak var postNumOfComments: UILabel!
    @IBOutlet weak var postNumOfEmojis: UILabel!
    @IBOutlet weak var imoLove: UIImageView!
    @IBOutlet weak var imoKiss: UIImageView!
    @IBOutlet weak var imoWow: UIImageView!
    @IBOutlet weak var btnmenubtn: UIButton!
    @IBOutlet weak var StoryTextLbl: UILabel!
    @IBOutlet weak var VerificationImg: UIImageView!
    
    var menuBtn:  (()->())?
    var playBtn:  (()->())?
    var likePost: (()->())?
    var kissPost: (()->())?
    var wowPost:  (()->())?
    var commentPost:  (()->())?
    var viewsPost:  (()->())?
    var viewEmoj:  (()->())?
    var profileBtn:  (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userPhoto.layer.cornerRadius = userPhoto.bounds.height / 2
        userPhoto.clipsToBounds = true
       
        postPhoto.layer.cornerRadius = 0.0
        postPhoto.clipsToBounds = true
        
        PostVideo.layer.cornerRadius = 0.0
        PostVideo.clipsToBounds = true
 
        likesView.layer.cornerRadius = 10.0
        likesView.clipsToBounds = true
        
        viewsView.layer.cornerRadius = 5.0
        viewsView.clipsToBounds = true

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func openimageMenu(_ sender: UIButton) {
        menuBtn?()
    }

    @IBAction func openProfile(_ sender: UIButton) {
        profileBtn?()
    }
    
    @IBAction func likePost(_ sender: UIButton) {
        sender.pulsate()
        likePost?()
    }
    @IBAction func kissPost(_ sender: UIButton) {
        sender.pulsate()
        kissPost?()
    }
    @IBAction func wowPost(_ sender: UIButton) {
        sender.pulsate()
        wowPost?()
    }
    
    @IBAction func openBtn(_ sender: UIButton) {
        playBtn?()
    }
    @IBAction func previewComment(_ sender: UIButton) {
        commentPost?()
    }
    
    @IBAction func previewViews(_ sender: UIButton) {
        viewsPost?()
    }
    @IBAction func previewEmoji(_ sender: UIButton) {
        viewEmoj?()
    }
}
