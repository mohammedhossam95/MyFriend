//
//  APi+Settings.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/27/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ApiCalls {
    //Mark :- Account Settings
    
    class func getSettings(completion: @escaping (_ error: Error?, _ account: Account?)->Void)  {
        let url = URLs.userSettings
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil)
            return
        }
        let parameters =
            [
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string, status == "true" {
                        guard let dataArr = json["properties"]["data"].array else {
                            completion(nil, nil)
                            return
                        }
                        //var profile = Profile()
                        // guard let data = dataArr[0].dictionary else { return }
                        
                        let firstPost = Account()
                        /*
                         var show_me : String = ""
                         var age_from : Int = 0
                         var age_to : Int = 0
                         var new_matches : Bool = false
                         var messages : Bool = false
                         */
                        
                        
                        firstPost.show_me = dataArr[0]["show_me"].string ?? ""
                        firstPost.age_from = dataArr[0]["age_from"].int ?? 0
                        firstPost.age_to = dataArr[0]["age_to"].int ?? 0
                        firstPost.new_matches = dataArr[0]["new_matches"].bool ?? false
                        firstPost.privateAc = dataArr[0]["private"].bool ?? false
                        
                        completion(nil, firstPost)
                    } else {
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                        completion(nil,nil)
                    }
                }
        }
        
    }
    
    //Mark:- Update data
    class func updateSettings(showMe: String, age_from: String, age_to: String, new_matches: String, messages: String,completion: @escaping (_ error: Error?, _ success: Bool)->Void)  {
        let url = URLs.updateSettings
        guard let user_token = helper.getApiToken() else {
            completion(nil,false)
            return
        }
        let parameters: [String:Any] =
            [
                "user_token":user_token,
                "show_me":showMe,
                "age_from":age_from,
                "age_to":age_to,
                "new_matches":new_matches,
                "private":messages,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string, status == "true" {
                        completion(nil, true)
                    } else {
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                        completion(nil,false)
                    }
                }
        }
        
    }
    
    
}
