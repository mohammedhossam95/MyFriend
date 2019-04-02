//
//  searchCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class searchCell: UITableViewCell {
    
    @IBOutlet weak var senderPhoto: UIImageView!
    @IBOutlet weak var snderName: UILabel!
    
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
    func configreCell(user: RandomUser) {
        snderName.text = user.name
        
        senderPhoto.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(user.avatar)")
        {
            senderPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
    }
    
}
