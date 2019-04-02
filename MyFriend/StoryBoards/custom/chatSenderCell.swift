//
//  chatSenderCell.swift
//  ChatV1.0
//
//  Created by Dev2 on 6/27/18.
//  Copyright © 2018 Hossam__95. All rights reserved.
//

import UIKit

class chatSenderCell: UITableViewCell {

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
