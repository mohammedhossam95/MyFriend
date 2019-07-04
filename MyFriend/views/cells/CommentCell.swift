//
//  CommentCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var senderPhoto: UIImageView!
    @IBOutlet weak var snderName: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var timeTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderPhoto.layer.borderWidth = 1
        senderPhoto.layer.masksToBounds = false
        senderPhoto.layer.borderColor = UIColor(hexString: "F2F2F2").cgColor
        senderPhoto.layer.cornerRadius = senderPhoto.bounds.height / 2
        senderPhoto.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configreCell(user: Comment) {
        snderName.text = user.name
        commentTxt.text = user.comment
        timeTxt.text = user.date
        
        senderPhoto.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(user.avatar)")
        {
            senderPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
    }
    
}
