//
//  ResetPasswordVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 3/12/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var rePassTxt: UITextField!
    @IBOutlet weak var codeTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func closeView(_ sender: UIButton) {
        navigationController?.popToViewController(backIndex: 2, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //verify
            if let pass = passTxt.text, let repass = rePassTxt.text {
                if pass == repass {
                    self.showLoading()
                    self.checkInput()
                }else{
                    showError(LoginError.passwordMismatch)
                }
            }
        
    }
    
    @IBAction func gmailLoginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    func setupView() {
        
        loginBtn.layer.cornerRadius = 10.0
        loginBtn.clipsToBounds = true
        
        codeTxt.layer.cornerRadius = 20.0
        codeTxt.clipsToBounds = true
        codeTxt.layer.borderWidth = 1
        codeTxt.layer.masksToBounds = false
        codeTxt.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        passTxt.layer.cornerRadius = 20.0
        passTxt.clipsToBounds = true
        passTxt.layer.borderWidth = 1
        passTxt.layer.masksToBounds = false
        passTxt.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        rePassTxt.layer.cornerRadius = 20.0
        rePassTxt.clipsToBounds = true
        rePassTxt.layer.borderWidth = 1
        rePassTxt.layer.masksToBounds = false
        rePassTxt.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        
        codeTxt.attributedPlaceholder = NSAttributedString(string: "code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        rePassTxt.attributedPlaceholder = NSAttributedString(string: "Re Enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
    }
    
}
extension ResetPasswordVC {
    func checkInput()  {
       
        do {
            let email = try verifyInput(emailTextField: codeTxt)
            let password  = try verifyInput(passwordTextField: passTxt)
            let rePassword = try verifyInput(passwordTextField: rePassTxt)

            ApiCalls.resetUserPassword(code: email, password: password, rePassword: rePassword) { (error: Error?, success: Bool, exception: String) in
                if success {
                    self.hideLoading()
                    self.showAlertsuccess(title: exception)
                    let alert = UIAlertController(title: exception, message: "Try Login by New Password", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Login", style: .default) { (action) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let SB = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(SB, animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                }else {
                    self.hideLoading()
                    self.showAlertError(title: exception)
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
        let alert = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        self.hideLoading()
        self.present(alert, animated: true, completion: nil)
        
    }
    enum LoginError: LocalizedError {
        case userNameCount, userNameEmpty, emailEmpty, emailNotValid, passwordEmpty, passwordCount,passwordMismatch
        var localizedDescription: String{
            switch self {
            case .userNameCount:
                return "Please insert valid Email or phone"
            case .userNameEmpty:
                return "Please insert your Email or phone"
            case .emailEmpty:
                return "Please insert Valid Code"
            case .emailNotValid:
                return "Please insert valid Email"
            case .passwordEmpty:
                return "Please insert your password"
            case .passwordMismatch:
                return "password Mis Match \n Enter valid one"
            case .passwordCount:
                return "Please check Your Password"
                
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
        guard let email = emailTextField.text, emailTextField.hasText else {
            throw LoginError.emailEmpty
        }
        return email
    }
}
