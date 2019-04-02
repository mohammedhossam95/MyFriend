//
//  galleryCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/11/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class galleryAddCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryAddPhoto: UIImageView!
    @IBOutlet weak var addCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addCell.layer.cornerRadius = 15.0
        addCell.clipsToBounds = true
    }
}

class galleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryPhoto: UIImageView!
    @IBOutlet weak var galleryVideo: UIView!
    @IBOutlet weak var deleteimgBtn: UIButton!
    
    var deletePost: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        galleryPhoto.layer.cornerRadius = 15.0
        galleryPhoto.clipsToBounds = true
        
        galleryVideo.layer.cornerRadius = 15.0
        galleryVideo.clipsToBounds = true
        galleryVideo.borderWidth = 1.0
        galleryVideo.borderColor = UIColor(hexString: "cccccc")
        galleryVideo.layer.masksToBounds = false
    }
    @IBAction func deletePhoto(_ sender: UIButton) {
        deletePost?()
    }
}
