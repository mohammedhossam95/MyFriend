//
//  RegisterVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/11/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import CountryList

class RegisterVC: BaseViewController, CountryListDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var codeLbl: UILabel!
    
    var countryList = CountryList()
    var code: String = "20"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        countryList.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        self.showLoading()
        self.checkInput()
        
    }
    
    @IBAction func openCookiesBtn(_ sender: UIButton) {
        guard let url = URL(string: "https://www.myfriend-app.com/about-cookies") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func openPolicyBtn(_ sender: UIButton) {
        guard let url = URL(string: "https://www.myfriend-app.com/data-policy") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func openTermsBtn(_ sender: UIButton) {
        guard let url = URL(string: "https://www.myfriend-app.com/privacy-policy") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    @IBAction func codePresssed(_ sender: UIButton) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func selectedCountry(country: Country) {
        self.codeLbl.text = "\(country.flag!), \(country.countryCode), \(country.phoneExtension)"
        code = country.phoneExtension
    }
    
    
    func setupView() {
        
        createBtn.layer.cornerRadius = 17.0
        createBtn.clipsToBounds = true
        
        nameText.layer.cornerRadius = 20.0
        nameText.clipsToBounds = true
        nameText.layer.borderWidth = 1
        nameText.layer.masksToBounds = false
        nameText.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        /*
         emailText.layer.cornerRadius = 20.0
         emailText.clipsToBounds = true
         emailText.layer.borderWidth = 1
         emailText.layer.masksToBounds = false
         emailText.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
         */
        
        emailView.layer.cornerRadius = 20.0
        emailView.clipsToBounds = true
        emailView.layer.borderWidth = 1
        emailView.layer.masksToBounds = false
        emailView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        
        passText.layer.cornerRadius = 20.0
        passText.clipsToBounds = true
        passText.layer.borderWidth = 1
        passText.layer.masksToBounds = false
        passText.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        nameText.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailText.attributedPlaceholder = NSAttributedString(string: "Email Or Phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        self.codeLbl.text = "🇪🇬, EG, 20"
    }
    
}
extension RegisterVC {
    func checkInput()  {
        let email:String
        do {
            if emailText.text?.isPhoneNumber == true, code != "" {
                email = emailText.text!
            }else{
                // codeLbl.isHidden = true
                email = try verifyInput(emailTextField: emailText)
            }
            let name = try verifyInput(NameTextField: nameText)
            let password = try verifyInput(passwordTextField: passText)
            
            ApiCalls.registerUser(name: name, username: email, ccode: code, password: password) { (error: Error?, success: Bool) in
                if success {
                    self.hideLoading()
                    print("User registered successfully")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let SB = storyboard.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
                    self.navigationController?.pushViewController(SB, animated: true)
                    
                }else {
                    self.hideLoading()
                    print(error?.localizedDescription as Any)
                }
            }
        } catch {
            guard let error = error as? LoginError else {
                return
            }
            showError(error)
        }
        
    }
    
    func showError(_ error: LoginError) {
        //show aleert
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        self.hideLoading()
        self.present(alert, animated: true, completion: nil)
        
    }
    enum LoginError: LocalizedError {
        case userNameCount, userNameEmpty, emailEmpty, emailNotValid, passwordEmpty, passwordCount
        var localizedDescription: String{
            switch self {
            case .userNameCount:
                return "Please insert valid user name, برجاء ادخال الاسم صحيح "
            case .userNameEmpty:
                return "Please insert your name, برجاء ادخال اسم صحيح"
            case .emailEmpty:
                return "Please insert valid user name, برجاء ادخال رقم تليفون صحيح او بريد صحيح"
            case .emailNotValid:
                return "Please insert valid user name, برجاء ادخال رقم تليفون صحيح او بريد صحيح"
            case .passwordEmpty:
                return "Please insert your password, برجاء ادخال كلمة سر "
            case .passwordCount:
                return "Please insert valid password, برجاء ادخال كلمة سر صحيحة"
                
            }
        }
        
    }

    func verifyInput(userNameTextField: UITextField) throws -> String{
        
        guard userNameTextField.hasText else {
            throw LoginError.userNameEmpty
        }
        guard let name = userNameTextField.text, name.count > 5 else {
            throw LoginError.userNameCount
        }
        return name
    }
    func verifyInput(NameTextField: UITextField) throws -> String{
        
        guard NameTextField.hasText else {
            throw LoginError.userNameEmpty
        }
        guard let name = NameTextField.text, name.count > 0 else {
            throw LoginError.userNameCount
        }
        return name
    }
    
    func verifyInput(passwordTextField: UITextField) throws -> String{
        guard passwordTextField.hasText else {
            throw LoginError.passwordEmpty
        }
        guard let password = passwordTextField.text, password.count > 4 else {
            throw LoginError.passwordCount
        }
        return password
    }
    
    func verifyInput(emailTextField: UITextField) throws -> String{
        guard emailTextField.hasText else {
            throw LoginError.emailEmpty
        }
        guard let email = emailTextField.text, email.isValidEmail != false else {
            throw LoginError.emailNotValid
        }
        return email
    }
}
