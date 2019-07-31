//
//  ApiCalls.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiCalls: NSObject {
    
    
    class func loginUser(phone: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool, _ exception: String)->Void){
        let url = URLs.login
        let parameters =
            [
                "username":phone,
                "password":password,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false, "")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    // let def = UserDefaults.standard
                    if let status = json["properties"]["status"].string,status ==  "true"{
                    if let userData = json["properties"]["data"].array,userData.count > 0{
                      
                        
                        if let user_token = userData[0]["user_token"].string {
                            // get contact type
                            print(user_token)
                            helper.saveApiToken(token: user_token)
                        }
                        
                        if let userName = userData[0]["username"].string,let bgGallery = userData[0]["bgGallery"].string,let avatar = userData[0]["avatar"].string,let user_id = userData[0]["user_id"].int {
                            helper.saveUserInfo(user_id: user_id, username: userName, avatar: avatar, bgGallery: bgGallery)
                        }
                        completion(nil,true, "")
                    }
                    }else if let exception = json["properties"]["exception"].string,exception ==  "Account not activated" {
                        completion(nil,false, "Account not activated")
                    }
                    else{
                        completion(nil,false, "")
                    }
                    
                }
                
                
        }
        
    }
//        https://www.myfriend-app.com/api/v1/auth/activation
    class func confirmUser(activation_key: Int, completion: @escaping (_ error: Error?, _ success: Bool)->Void){
        let url = URLs.confirm
        let parameters: [String:Any] =
            [
                "activation_key":activation_key,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    // let def = UserDefaults.standard
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        if let userData = json["properties"]["data"].array,userData.count > 0{
                            //  print(userData)
                            
                            if let user_token = userData[0]["user_token"].string {
                                // get contact type
                                print(user_token)
                                helper.saveApiToken(token: user_token)
                            }
                            
                            if let userName = userData[0]["username"].string,let bgGallery = userData[0]["bgGallery"].string,let avatar = userData[0]["avatar"].string,let user_id = userData[0]["user_id"].int {
                                // get contact type
                                print(userName)
                                //helper.saveUserInfo(user_id: user_id, username: userName, avatar: avatar)
                                helper.saveUserInfo(user_id: user_id, username: userName, avatar: avatar, bgGallery: bgGallery)
                            }
                            
                            completion(nil,true)
                        }
                        
                    }else{
                        completion(nil,false)
                    }
                    
                }
                
                
        }
        
    }
    class func registerUser(name: String, username: String, ccode: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void){
        let url = URLs.register
        let parameters =
            [
                "name":name,
                "ccode":ccode,
                "username":username,
                "password":password,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    // let def = UserDefaults.standard
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        
                        completion(nil,true)
                        
                    }else{
                        completion(nil,false)
                    }
                }
        }
        
    }
    class func forgetUserPassword(phone: String, completion: @escaping (_ error: Error?, _ success: Bool, _ exception: String)->Void){
        let url = URLs.forgetPassword
        let parameters =
            [
                "username":phone,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false, "")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    // let def = UserDefaults.standard
                    if let status = json["properties"]["status"].string,status ==  "true"{
                            if let exception = json["properties"]["exception"].string {
                                completion(nil,true, exception)
                            }
                    }else if let exception = json["properties"]["exception"].string{
                        completion(nil,false, exception)
                    
                    }else{
                        completion(nil,false, "")
                    }
                }
        }
        
    }
    //Reset Password
    class func resetUserPassword(code: String, password: String, rePassword: String, completion: @escaping (_ error: Error?, _ success: Bool, _ exception: String)->Void){
        let url = URLs.resetPassword
        let parameters =
            [
                "activation_key":code,
                "password":password,
                "con_password":rePassword,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false, "")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        if let exception = json["properties"]["exception"].string{
                            completion(nil,true, exception)
                        }
                    }else if let exception = json["properties"]["exception"].string,exception ==  "Incorrect Activation key" {
                        completion(nil,false, "Incorrect Activation key")
                    }
                    else{
                        completion(nil,false, "")
                    }
                    
                }
                
                
        }
        
    }
}
