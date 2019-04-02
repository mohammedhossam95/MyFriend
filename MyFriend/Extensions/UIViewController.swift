//
//  UIViewController.swift
//  LiveHealthy
//
//  Created by Mohamed Tarek on 5/15/17.
//  Copyright © 2017 Yackeen Solutions. All rights reserved.
//

import UIKit

extension UIViewController{
    
    // create a new style
    
    
    // this is just one of many style options
    
    func showSuccessAlertWithTitle(title: String, message: String) {

//        var style = ToastStyle()
//        style.messageColor = .white
//        
//        self.view.makeToast(message, duration: 1.5, position: .bottom, style: style)

     //   SCLAlertView().showSuccess(title, subTitle: message)
        
        
    }
    
    
    
    func showErrorAlertWithTitle(title: String, message: String) {

     //   SCLAlertView().showError(title, subTitle: message)
        
        
    }
    
    
    
    func showWarninigAlertWithTitle(title: String, message: String) {
        
     //   SCLAlertView().showWarning(title, subTitle: message)
        
        
    }
    
    
    
    func isNotEmptyString(text: String, withAlertMessage message: String) -> Bool{
        if text == ""{
            showWarninigAlertWithTitle(title: "Warning".localized, message: message)
            
            return false
        }
        else{
            return true
        }
    }
    
    func isEmailVaild(emailString: String) -> Bool{
        let regExPattern = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regExPattern])
        if !emailTest.evaluate(with: emailString){
            showErrorAlertWithTitle(title: "Alert".localized, message: "Please, Insert Email Correctly".localized)
        }
        return emailTest.evaluate(with: emailString)
    }
    
    func isPhoneNumberValid(phoneNumber: String) -> Bool{
        var isValid = true
        let nameValidation = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if (nameValidation.utf8.count < 9 || nameValidation.utf8.count > 14) { //check length limitation
            isValid = false
        }
        
        if !isValid{
            showWarninigAlertWithTitle(title: "Warning".localized, message: "Please, Insert Phone Number Correctly".localized)
        }
        
        return isValid
    }
    // edit
    class func with(storyBoardName : String, identifier : String ) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyBoardName, bundle:Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
