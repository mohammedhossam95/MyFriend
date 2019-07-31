//
//  ForgetPassVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 3/12/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ForgetPassVC: BaseViewController {
    
    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
//    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func createNewAccountPressed(_ sender: UIButton) {
        
    }
    @IBAction func closeForgetView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        //verify
        showLoading()
        self.checkInput()
        //call api
        //handle response
        
        // helper.saveApiToken()
        
    }
    
    @IBAction func gmailLoginPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    func setupView() {
        
        loginBtn.layer.cornerRadius = 10.0
        loginBtn.clipsToBounds = true
        
        emailView.layer.cornerRadius = 20.0
        emailView.clipsToBounds = true
        emailView.layer.borderWidth = 1
        emailView.layer.masksToBounds = false
        emailView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor

        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Or Phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}
extension ForgetPassVC {
    func checkInput()  {
        let email:String
        do {
            if emailTxt.text?.isPhoneNumber == true {
                email = emailTxt.text!
            }else{
                email = try verifyInput(emailTextField: emailTxt)
            }
            ApiCalls.forgetUserPassword(phone: email) { (error: Error?, success: Bool, exception: String) in
                if success && exception != ""{
                    self.hideLoading()
                    self.showAlertsuccess(title: exception)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let SB = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    self.navigationController?.pushViewController(SB, animated: true)
                }else {
                    self.showAlertError(title: "Something went wrong, Try again")
                    self.hideLoading()
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
                return "Please insert valid Email or phone"
            case .userNameEmpty:
                return "Please insert your Email or phone"
            case .emailEmpty:
                return "Please insert your Email"
            case .emailNotValid:
                return "Please insert valid Email"
            case .passwordEmpty:
                return "Please insert your password"
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
        guard emailTextField.hasText else {
            throw LoginError.emailEmpty
        }
        guard let email = emailTextField.text, email.isValidEmail != false else {
            throw LoginError.emailNotValid
        }
        return email
    }
}
