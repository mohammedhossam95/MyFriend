//
//  TinderCard.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/20/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//
import UIKit
import Kingfisher

class TinderCard: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet var backImg: UIImageView!
    @IBOutlet var user_img: UIImageView!
    @IBOutlet weak var overlay: UIImageView!
    
    @IBOutlet weak var verifyImage: UIImageView!
    @IBOutlet var card_userTitleLbl: UILabel!
    @IBOutlet var card_followersLbl: UILabel!
    @IBOutlet var card_genderLbl: UILabel!
    @IBOutlet var card_statusLbl: UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {

        backgroundColor = .white
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.2
        addSubview(view)
        
        
        backImg.layer.cornerRadius = 15.0
        backImg.clipsToBounds = true
        
        overlay.layer.cornerRadius = 15.0
        overlay.clipsToBounds = true

        user_img.layer.cornerRadius = user_img.bounds.height / 2
        user_img.clipsToBounds = true

        user_img.layer.borderWidth = 1
        user_img.layer.masksToBounds = true
        user_img.layer.borderColor = UIColor(hexString: "f92d2d").cgColor

    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func configureCell(viewModelCard: Follower)  {
        
        backImg.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(viewModelCard.background)"){
            backImg.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
       
        user_img.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(viewModelCard.avatar)"){
            user_img.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        
        card_userTitleLbl.text = viewModelCard.name
        card_followersLbl.text = "\(viewModelCard.followers) Followers"
        card_genderLbl.text = "\(viewModelCard.age) \(viewModelCard.gender)"
        if viewModelCard.verified == 0 {
            verifyImage.isHidden = true
        }else {
            verifyImage.isHidden = false
        }
        if viewModelCard.online == 0 {
            card_statusLbl.text = "Offline"
        }else {
            card_statusLbl.text = "online"
        }
    }

    
}

