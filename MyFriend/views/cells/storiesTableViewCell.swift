//
//  storiesTableViewCell.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/24/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class storiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storiesCollection: UICollectionView!
    @IBOutlet weak var addstorybackground: UIImageView!
    @IBOutlet weak var addcam: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addcam.layer.cornerRadius = addcam.bounds.height / 2
        addcam.clipsToBounds = true
        addstorybackground.layer.cornerRadius = 10.0
        addstorybackground.clipsToBounds = true
    }
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D) {
        
        storiesCollection.delegate = dataSourceDelegate
        storiesCollection.dataSource = dataSourceDelegate
        //storiesCollection.tag = row
        storiesCollection.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
