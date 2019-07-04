//
//  photoMessageCell.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/2/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class photoMessageCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImage.layer.borderWidth = 1
        photoImage.layer.masksToBounds = false
        photoImage.layer.borderColor = UIColor.blue.cgColor
        photoImage.layer.cornerRadius = 10.0
        photoImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
class photorecieverCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImage.layer.borderWidth = 1
        photoImage.layer.masksToBounds = false
        photoImage.layer.borderColor = UIColor.red.cgColor
        photoImage.layer.cornerRadius = 10.0
        photoImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
