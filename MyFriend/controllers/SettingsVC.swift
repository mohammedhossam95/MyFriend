//
//  SettingsVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/10/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import TTRangeSlider

class SettingsVC: BaseViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var maleInterstsBtn: UIButton!
    @IBOutlet weak var femaleInterstsBtn: UIButton!
    @IBOutlet weak var bothInterstsBtn: UIButton!
    @IBOutlet weak var interstsView: UIView!
    @IBOutlet weak var switchesView: UIView!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var bothBtn: UIButton!
    @IBOutlet weak var range: TTRangeSlider!
    @IBOutlet weak var matchesSwitch: UISwitch!
    @IBOutlet weak var messagesSwitch: UISwitch!
    var intersts = ""
    
    var settings = Account()
    //var  selected =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        handleRefresh()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh()  {

        self.showLoading()
        ApiCalls.getSettings { (error: Error?, account: Account?) in
            if let account = account{
                self.hideLoading()
                self.settings = account
                self.updateUI(settings: account)
            }
        }
    }
    
    @IBAction func malePressed(_ sender: UIButton) {
        beforeChange()
        maleBtn.backgroundColor = UIColor(hexString: "f92d2d")
        maleBtn.titleLabel?.textColor = UIColor.white
        intersts = "Male"
    }
    
    @IBAction func femalePressed(_ sender: UIButton) {
        beforeChange()
        femaleBtn.backgroundColor = UIColor(hexString: "f92d2d")
        femaleBtn.titleLabel?.textColor = UIColor.white
        intersts = "Female"
    }
    
    @IBAction func bothInterstsPressed(_ sender: UIButton) {
        beforeChange()
        bothBtn.backgroundColor = UIColor(hexString: "f92d2d")
        bothBtn.titleLabel?.textColor = UIColor.white
        intersts = "Both"
    }
    
    @IBAction func settingsBackPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    
    @IBAction func SavePressed(_ sender: UIButton) {

        self.showLoading()
        print(intersts)
        print(matchesSwitch.isOn)
        print(messagesSwitch.isOn)
        print(range.selectedMinimum)
        let minRange = String(range.selectedMinimum)
        let maxRange = String(range.selectedMaximum)
        let new_matches = String(matchesSwitch.isOn)
        let messages = String(messagesSwitch.isOn)
        
        ApiCalls.updateSettings(showMe: intersts, age_from: minRange, age_to: maxRange, new_matches: new_matches, messages: messages) { (error: Error?, success: Bool) in
            if success {
                self.hideLoading()
                let alertController = UIAlertController(title: "Settings", message: "User Settings Updated Succesfully", preferredStyle: .alert)
                
                let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    print("Cancel btn")
                }
                alertController.addAction(cancelBtn)
                self.navigationController?.present(alertController, animated: true, completion: nil)
                
            }else {
                self.hideLoading()
                print(error as Any)
                let alertController = UIAlertController(title: "Error", message: "Check Connection and try Again", preferredStyle: .alert)
                
                let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    print("Cancel btn")
                }
                alertController.addAction(cancelBtn)
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func setupView() {
        self.beforeChange()
        maleInterstsBtn.layer.cornerRadius = 25.0
        maleInterstsBtn.clipsToBounds = true
        
        femaleInterstsBtn.layer.cornerRadius = 25.0
        femaleInterstsBtn.clipsToBounds = true
        
        bothInterstsBtn.layer.cornerRadius = 25.0
        bothInterstsBtn.clipsToBounds = true
        
        interstsView.layer.cornerRadius = 25.0
        interstsView.clipsToBounds = true
        
        switchesView.layer.cornerRadius = 25.0
        switchesView.clipsToBounds = true
        
        saveBtn.layer.cornerRadius = 15.0
        saveBtn.clipsToBounds = true
    }
    func beforeChange() {
        femaleBtn.backgroundColor = UIColor(hexString: "d9d9d9")
        maleBtn.backgroundColor = UIColor(hexString: "d9d9d9")
        bothBtn.backgroundColor = UIColor(hexString: "d9d9d9")
        femaleBtn.titleLabel?.textColor = UIColor.white
        maleBtn.titleLabel?.textColor = UIColor.white
        bothBtn.titleLabel?.textColor = UIColor.white
    }
    
    
    func updateUI(settings: Account) {
        
        range.selectedMinimum = Float(settings.age_from)
        range.selectedMaximum = Float(settings.age_to)
        
        switch settings.show_me {
        case "Male":
            maleBtn.backgroundColor = UIColor(hexString: "f92d2d")
        case "Female":
            femaleBtn.backgroundColor = UIColor(hexString: "f92d2d")
        case "Both":
            bothBtn.backgroundColor = UIColor(hexString: "f92d2d")
            
        default:
            print("text")
            // maleBtn.backgroundColor = UIColor(hexString: "f92d2d")
        }
        if settings.new_matches == true{
            matchesSwitch.isOn = true
        }else{
            matchesSwitch.isOn = false
        }
        
        
        if settings.privateAc == true{
            messagesSwitch.isOn = true
        }else{
            messagesSwitch.isOn = false
        }
    }

}
