//
//  photosCollecViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/13/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class photosCollecViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoLoveView: UIView!
    @IBOutlet weak var photoKissView: UIView!
    @IBOutlet weak var photoWowView: UIView!
    @IBOutlet weak var numphotoLove: UILabel!
    @IBOutlet weak var numphotoKiss: UILabel!
    @IBOutlet weak var numphotoWow: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoLoveView.layer.cornerRadius = photoLoveView.bounds.height / 2
        photoLoveView.clipsToBounds = true
        
        photoKissView.layer.cornerRadius = photoKissView.bounds.height / 2
        photoKissView.clipsToBounds = true
        
        photoWowView.layer.cornerRadius = photoWowView.bounds.height / 2
        photoWowView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
}
