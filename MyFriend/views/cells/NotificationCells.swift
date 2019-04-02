//
//  NotificationCells.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/11/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

class TwoImagesNotificationCell: UITableViewCell {
    
    @IBOutlet weak var type2bigView: UIView!
    @IBOutlet weak var type2NotificationTypeImage: UIImageView!
    @IBOutlet weak var type2NotificationUserPhoto: UIImageView!
    @IBOutlet weak var type2NotificationUserName: UILabel!
    @IBOutlet weak var type2NotificationUserTime: UILabel!
    @IBOutlet weak var type2NotiificationText: UILabel!
    @IBOutlet weak var type2Image: UIImageView!
    @IBOutlet weak var videoView: UIView!
    
    var openImage:  (()->())?
    var openProfile:  (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        type2NotificationUserTime.textColor = UIColor(hexString: "888888")
        type2bigView.layer.cornerRadius = 10.0
        type2bigView.clipsToBounds = true
        type2NotificationUserPhoto.layer.borderWidth = 1
        type2NotificationUserPhoto.layer.masksToBounds = false
        type2NotificationUserPhoto.layer.borderColor = UIColor.black.cgColor
        type2NotificationUserPhoto.layer.cornerRadius = type2NotificationUserPhoto.bounds.height / 2
        type2NotificationUserPhoto.clipsToBounds = true
        type2NotiificationText.textColor = UIColor(hexString: "888888")
        type2Image.layer.cornerRadius = 10.0

    }
    
    @IBAction func openphoto(_ sender: UIButton) {
        openImage?()
    }
    
    @IBAction func open(_ sender: UIButton) {
        openProfile?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class TwoButtonsNotificationCell: UITableViewCell {
    
    @IBOutlet weak var type3bigView: UIView!
    @IBOutlet weak var type3NotificationTypeImage: UIImageView!
    @IBOutlet weak var type3NotificationUserPhoto: UIImageView!
    @IBOutlet weak var type3NotificationUserName: UILabel!
    @IBOutlet weak var type3NotificationUserTime: UILabel!
    @IBOutlet weak var type3NotificationText: UILabel!
    @IBOutlet weak var type3NotificationBtnFollow: UIButton!
    @IBOutlet weak var type3NotificationBtnReject: UIButton!
    
    var confirmBtn:  (()->())?
    var rejectBtn:  (()->())?
    var openProfile:  (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        type3bigView.layer.cornerRadius = 15.0
        type3bigView.clipsToBounds = true
        type3NotificationUserPhoto.layer.borderWidth = 1
        type3NotificationUserPhoto.layer.masksToBounds = false
        type3NotificationUserPhoto.layer.borderColor = UIColor.black.cgColor
        type3NotificationUserPhoto.layer.cornerRadius = type3NotificationUserPhoto.bounds.height / 2
        type3NotificationUserPhoto.clipsToBounds = true
        
        type3NotificationBtnFollow.layer.cornerRadius = 10.0
        type3NotificationBtnFollow.clipsToBounds = true
        type3NotificationBtnReject.layer.cornerRadius = 10.0
        type3NotificationBtnReject.clipsToBounds = true
        
    }
    @IBAction func confirmBtn(_ sender: UIButton) {
        confirmBtn?()
    }
    @IBAction func rejectBtn(_ sender: UIButton) {
        rejectBtn?()
    }
    //var openProfile:  (()->())?
    @IBAction func openProfileBtn(_ sender: UIButton) {
        openProfile?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SimpleNotificationCell: UITableViewCell {
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var notificationTypeImage: UIImageView!
    @IBOutlet weak var notificationUserPhoto: UIImageView!
    @IBOutlet weak var notificationUserName: UILabel!
    @IBOutlet weak var notificationUserTime: UILabel!
    @IBOutlet weak var notificationText: UILabel!
    
    var openProfile:  (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bigView.layer.cornerRadius = 15.0
        bigView.clipsToBounds = true
        notificationUserPhoto.layer.borderWidth = 1
        notificationUserPhoto.layer.masksToBounds = false
        notificationUserPhoto.layer.borderColor = UIColor.black.cgColor
        notificationUserPhoto.layer.cornerRadius = notificationUserPhoto.bounds.height / 2
        notificationUserPhoto.clipsToBounds = true
        notificationText.textColor = UIColor(hexString: "888888")
    }
    
    @IBAction func openpro(_ sender: UIButton) {
        openProfile?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
