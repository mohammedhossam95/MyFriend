//
//  ProfileMenuCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ProfileMenuCell: UICollectionViewCell {
    @IBOutlet weak var menuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuTitle.alpha = 0.6
    }
    func setupTitle(text: String){
        menuTitle.text = text
    }
    
    override var isSelected: Bool{
        didSet{
            menuTitle.alpha = isSelected ? 1.0 : 0.6
        }
    }
}
