//
//  pod 'OTPTextView' ConfirmationVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/1/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import OTPTextView

class ConfirmationVC: BaseViewController, OTPTextViewDelegate {

    
    @IBOutlet weak var activationView: UIView!
    @IBOutlet weak var confirmbtn: UIButton!
    @IBOutlet weak var OTPTextVU: OTPTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        self.showLoading()
        print(OTPTextVU.getNumber() as Any)
        if let key = Int(OTPTextVU.getNumber()!){
            ApiCalls.confirmUser(activation_key: key) { (error: Error?, success: Bool) in
                if success {
                        self.hideLoading()
                        print("User activation successfully")
                   
                }else {
                    self.hideLoading()
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    
    func OTPTextViewResult(number: String?) {
        if number != nil
        {
            let alert = UIAlertController(title: "Alert", message: number, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupView() {
        
        confirmbtn.layer.cornerRadius = 15.0
        confirmbtn.clipsToBounds = true
        
        activationView.layer.cornerRadius = 15.0
        activationView.clipsToBounds = true
        activationView.layer.borderWidth = 1
        activationView.layer.masksToBounds = false
        activationView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        
        OTPTextVU.layer.cornerRadius = 10
        OTPTextVU.delegate = self
        OTPTextVU.indicatorStyle = .underlineProgress
       // OTPTextVU.borderColor = .blue // Default border color
        
        OTPTextVU.onErrorBorderColor = .red // the color when one textfield is empty
        OTPTextVU.onEnterBoarderColor = .orange // the color when textfield gets the focus
        OTPTextVU.onLeaveBoarderColor =  .blue // the color when textfield loses the focus
        OTPTextVU.onFilledBorderColor = .blue // the color when textfield is filled and loses the focu
        OTPTextVU.onSuccessBoarderColor = .blue // the color when codes is right
        OTPTextVU.IndicatorGapeFromTop = 4 //
        OTPTextVU.isBorderHidden = false
        OTPTextVU.isPasswordProtected = false
        OTPTextVU.forceCompletion = false
        OTPTextVU.callOnCompleted = false
        OTPTextVU.AutoArrange = true
        OTPTextVU.isBorderHidden = false
        OTPTextVU.onEnterBorderWidth = 2
        OTPTextVU.onLeaveBorderWidth = 1
        OTPTextVU.borderSize = 1
        OTPTextVU.BorderRadius = 10
        OTPTextVU.isFirstResponser = false
        OTPTextVU.BlockSize = CGSize(width: 35, height: 50)
        OTPTextVU.BlocksNo = 6
        OTPTextVU.gape = 10
        OTPTextVU.showCursor = false
        OTPTextVU.fontSize = 18
        
        
        
    }
}
