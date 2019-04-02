//
//  UIImageViewExtension.swift
//  Naqelat
//
//  Created by Mahmoud El-Sayed on 9/24/17.
//  Copyright © 2017 Asgatech. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func setImageWith(stingUrl : String, placeholder : UIImage? = nil) {
        
        let url = URL(string: !stingUrl.isEmpty ? stingUrl : "http//" )!
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         placeholder: placeholder,
                         options: [.transition(.fade(1))],
                         progressBlock: nil,
                         completionHandler: nil)
    }
    
    open func setImage(string: String?,
                       color: UIColor? = nil,
                       circular: Bool = true,
                       textAttributes: [NSAttributedString.Key: Any]? = nil) {
        
        let image = imageSnap(text: string != nil ? string?.initials : "",
                              color: color ?? UIColor.white,
                              circular: circular,
                              textAttributes:textAttributes)
        
        if let newImage = image {
            self.image = newImage
        }
    }
    
    private func imageSnap(text: String?,
                           color: UIColor,
                           circular: Bool,
                           textAttributes: [NSAttributedString.Key: Any]?) -> UIImage? {
        
        let scale = Float(UIScreen.main.scale)
        var size = bounds.size
        if contentMode == .scaleToFill || contentMode == .scaleAspectFill || contentMode == .scaleAspectFit || contentMode == .redraw {
            size.width = CGFloat(floorf((Float(size.width) * scale) / scale))
            size.height = CGFloat(floorf((Float(size.height) * scale) / scale))
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPath(ellipseIn: bounds, transform: nil)
            context?.addPath(path)
            context?.clip()
        }
        
        // Fill
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Text
//        if let text = text {
//            let attributes = textAttributes ?? [(NSForegroundColorAttributeName as NSString) as NSAttributedStringKey: UIColor.white,
//                                                NSFontAttributeName as NSString: UIFont.systemFont(ofSize: 15.0)]
//            
//            let textSize = text.size(OfFont: UIFont.systemFont(ofSize: 15.0))
//            let bounds = self.bounds
//            let rect = CGRect(x: bounds.size.width/2 - textSize.width/2, y: bounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)
//            
//            text.draw(in: rect, withAttributes: attributes as [String : Any])
//        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
