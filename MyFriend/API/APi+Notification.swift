//
//  APi+Notification.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/20/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension ApiCalls{
    
    class func getnotifications(page: Int = 1, completion: @escaping (_ error: Error?, _ Notifications: [Notification]?, _ last_page: Int)->Void)  {
        let url = URLs.Notification
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,page)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "page":page,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil,page)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    guard let dataArr = json["properties"]["data"].array else {
                        completion(nil, nil,page)
                        return
                    }
                    var Notifications = [Notification]()
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstPost = Notification()
                        
                        firstPost.id = data["id"]?.int ?? 0
                        firstPost.userId = data["user_id"]?.int ?? 0
                        firstPost.name = data["name"]?.string ?? ""
                        firstPost.avatar = data["avatar"]?.string ?? ""
                        firstPost.online = data["online"]?.int ?? 0
                        firstPost.verified = data["verified"]?.int ?? 0
                        firstPost.reference_id = data["reference_id"]?.int ?? 0
                        firstPost.icons = data["emoji_icon"]?.string ?? ""
                        firstPost.mimo_type = data["mimo_type"]?.string ?? ""
                        firstPost.text = data["text"]?.string ?? ""
                        firstPost.reference = data["reference"]?.string ?? ""
                        firstPost.time = data["time"]?.string ?? ""
                        firstPost.date = data["date"]?.string ?? ""
                        firstPost.seen = data["seen"]?.int ?? 0
                        firstPost.type = data["type"]?.int ?? 0
                        
                        Notifications.append(firstPost)
                    }
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, Notifications,last_page)
                    
                }
        }
        
    }
    
}
