//
//  ChatTableViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderPhoto: UIImageView!
    @IBOutlet weak var snderName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var count_unread_msg: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var count_unread_msgView: UIView!
    
    var chatBtn:  (()->())?
    var profileBtn:  (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderPhoto.layer.borderWidth = 1
        senderPhoto.layer.masksToBounds = false
        senderPhoto.layer.borderColor = UIColor.black.cgColor
        senderPhoto.layer.cornerRadius = senderPhoto.bounds.height / 2
        senderPhoto.clipsToBounds = true
        count_unread_msgView.layer.cornerRadius = count_unread_msgView.bounds.height / 2
        count_unread_msgView.clipsToBounds = true
        
        
    }

    @IBAction func openProfile(_ sender: UIButton) {
        profileBtn?()
    }
    @IBAction func openChat(_ sender: UIButton) {
        chatBtn?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
