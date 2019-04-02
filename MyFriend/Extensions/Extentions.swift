//
//  Extentions.swift
//  Naqelat
//
//  Created by Khaled Saad on 10/30/17.
//  Copyright © 2017 Asgatech. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

extension UIApplication {
   class func initWindow(){
        (UIApplication.shared.delegate as! AppDelegate).setRootView()
    }
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: url)!)
                }
                
                return
            }
        }
    }
    
}

extension UIImage {
        static func from(color: UIColor) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    
    class func imageWithInitials(initials : String, size : CGSize) -> UIImage {
        
        let imageview = UIImageView.init(frame: CGRect.init(origin: .zero, size: size))
        imageview.setImage(string: initials, color:UIColor.init(hexString: Constants.yellowHexCode), circular: true, textAttributes: nil)
        
        return imageview.image!
        
    }
    func base64() -> String {
    let imageData = self.jpegData(compressionQuality: 0.4)!
     //  let imageData = UIImageJPEGRepresentation(self, 0.4)!
        return imageData.base64EncodedString()
    }
    static var incomingBubble : UIImage {
        return UIImage(named:"bubbleOut")!.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 22, bottom: 17, right: 20))
    }
   static var outgoingBubble : UIImage {
    return UIImage(named:"bubbleIn")!.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 22, bottom: 17, right: 20))

    }
}

extension Int {
    
    func localizedString() -> String {
        
        let arr = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        var result = String(self)
        if !UIApplication.isRTL() {
            return result
        } else {
            
            for int in 0...9 {
                result = result.replacingOccurrences(of: String(int), with: arr[int])
            }
            return result
        }
        
    }
    func localizedPrice() -> String  {
        
        return  "\(self.localizedString()) \("SAR".localized)"
    }
}
extension Double {
    
    func localizedString() -> String {
        
        let arr = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        var result = String(self)
        if !UIApplication.isRTL() {
            return result
        } else {
            
            for int in 0...9 {
                result = result.replacingOccurrences(of: String(int), with: arr[int])
            }
            return result
        }
        
    }
    func localizedPrice() -> String  {
        return  "\(self.localizedString()) \("SAR".localized)"
    }
}
extension UIButton {
    
    func setImageWith(urlString : String){
        
        let url = URL(string: !urlString.isEmpty ? urlString : "http//" )!
        self.kf.setImage(with: url, for: .normal)
        
    }
}
extension MKMapView {
    
    func zoomToLocatiom(location : CLLocation,level:Float = -1) {
        
        let viewRegion =  MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(level), longitudinalMeters: CLLocationDistance(level))
        
        let region = MKCoordinateRegion(center: location.coordinate,span: self.region.span)
        self.setRegion(level == -1 ? region : viewRegion , animated: false)
    }
    func drawRouts(routs : [MKRoute]) {
        for route in routs {
            
            if !self.overlays(in: .aboveRoads).isEmpty {
                self.removeOverlays(self.overlays(in: .aboveRoads))
            }
            self.addOverlay(route.polyline, level:.aboveRoads)
        }
        
    }
    var isRegionChangedByUser : Bool {
        
        let view = self.subviews.first
        
        for recognizer in (view?.gestureRecognizers)! {
            if recognizer.state == .began || recognizer.state == .ended || recognizer.state == .failed {
                return true
            }
            
        }
        
        return false;
    }
    
}
extension CLPlacemark {
    var fullAddress : String {
        
        var address = "Unidentified address"
        
        let addressArray = self.addressDictionary!["FormattedAddressLines"] as! [String]
        for string in addressArray{
            address.append("\(string),")
        }
        return address
    }
    var city :  String {
        
        if let str = self.addressDictionary!["City"] as? String {
            return str
        }
        if let str = self.addressDictionary!["Name"] as? String {
            return str
        }
        if let str = self.addressDictionary!["State"] as? String {
            return str
        }
        return ""
    }
}
extension UINavigationController {
    func popToViewController(backIndex : Int , animated : Bool)  {
        
        let index = self.viewControllers.count - backIndex - 1
        self.popToViewController(self.viewControllers[index], animated: animated)
        
    }
    func popToViewController(identifier : String , animated : Bool)  {
        
        for controller in self.viewControllers {
            if identifier == controller.restorationIdentifier {
                self.popToViewController(controller, animated: animated)
                return
            }
        }
    }
    func containsController(identifier : String) -> Bool {
        
        for controller in self.viewControllers {
            if identifier == controller.restorationIdentifier {
                return true
            }
        }
        return false
    }
    func controller(identifier : String) -> UIViewController? {
        
        for controller in self.viewControllers {
            if identifier == controller.restorationIdentifier {
                return controller
            }
        }
        return nil
    }
}


//// OUTPUT 2
//func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//    layer.masksToBounds = false
//    layer.shadowColor = color.cgColor
//    layer.shadowOpacity = opacity
//    layer.shadowOffset = offSet
//    layer.shadowRadius = radius
//    
//    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//    layer.shouldRasterize = true
//    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//}


extension UIView {
    
    func setShadow(color : UIColor = .lightGray,opacity : Float  = 1,radius : CGFloat = 5) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true

    }
    func setRounded(isRounded : Bool)  {
        self.clipsToBounds = true
        self.layer.cornerRadius = isRounded ? self.frame.size.height/2 : 0
    }
}

