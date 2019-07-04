//
//  chatRecieverCell.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class chatRecieverCell: UITableViewCell {
    
    @IBOutlet weak var senderMessageLbl: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
