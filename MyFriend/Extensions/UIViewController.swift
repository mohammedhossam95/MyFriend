//
//  UIViewController.swift
//  LiveHealthy
//
//  Created by Mohamed Tarek on 5/15/17.
//  Copyright © 2017 Yackeen Solutions. All rights reserved.
//

import UIKit
import SwiftMoment

extension UIViewController{
    // edit
    class func with(storyBoardName : String, identifier : String ) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyBoardName, bundle:Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func momentTime(webDate: String) -> String {
        let dat = "\(webDate)+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:dat)!
        let x = moment(date).fromNow()
        return x
    }
}
