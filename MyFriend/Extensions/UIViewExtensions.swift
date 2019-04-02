//
//  UIViewExtensions.swift
//  Challenge_App
//
//  Created by Khaled saad on 1/22/18.
//  Copyright © 2018 Asgatech. All rights reserved.
//

import UIKit

extension UIView {

    func screenshot() -> UIImage? {
//
//        UIGraphicsBeginImageContext(self.frame.size)
//        self.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//        return image
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
       drawHierarchy(in: bounds, afterScreenUpdates: true)
       let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return newImage
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

   // for all sides
//    let shadowSize : CGFloat = 5.0
//    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                               y: -shadowSize / 2,
//                                               width: self.avatarImageView.frame.size.width + shadowSize,
//                                               height: self.avatarImageView.frame.size.height + shadowSize))
//    self.avatarImageView.layer.masksToBounds = false
//    self.avatarImageView.layer.shadowColor = UIColor.black.cgColor
//    self.avatarImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//    self.avatarImageView.layer.shadowOpacity = 0.5
//    self.avatarImageView.layer.shadowPath = shadowPath.cgPath
    
    
    // MARK: for shadow in design

    @IBInspectable var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        get{
            return self.layer.shadowRadius
        }
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        get{
            return self.layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var borderColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    /*
 
     @IBInspectable var borderWidth: CGFloat = 0.0{
     
     didSet{
     
     self.layer.borderWidth = borderWidth
     }
     }
     
 */

}



