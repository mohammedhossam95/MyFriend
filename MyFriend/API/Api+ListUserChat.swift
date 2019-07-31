//
//  Api+ListUserChat.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/19/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftMoment

extension ApiCalls{
    
    class func listUserChats(page: Int = 1, completion: @escaping (_ error: Error?, _ UnRMessages: [unReadMessage]?, _ last_page: Int)->Void)  {
        
        let url = URLs.listUserChats
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
                    completion(nil,nil,page)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    guard let dataUnread_messages = json["properties"]["messages"].array else {
                        completion(nil,nil,page)
                        return
                    }
                    
                    var Unread_messages = [unReadMessage]()

                    for data in dataUnread_messages {
                        guard let data = data.dictionary else { return }
                        let unMessage = unReadMessage()
                        unMessage.user_id = data["user_id"]?.int ?? 0
                        unMessage.avatar = data["avatar"]?.string ?? ""
                        unMessage.name = data["name"]?.string ?? ""
                        unMessage.verified = data["verified"]?.int ?? 0
                        unMessage.seen = data["seen"]?.int ?? 0
                        unMessage.online = data["online"]?.int ?? 0
                        unMessage.last_message_icon = data["last_message_icon"]?.string ?? ""
                        let strDate = "\(data["created_at"]?.string ?? "")"
                        print(strDate," test ",moment(strDate.timestamp).fromNow())
                        unMessage.created_at = moment(strDate.timestamp).fromNow()
//                        unMessage.created_at = data["created_at"]?.string ?? ""
                        
                        unMessage.count_unread_msg = data["count_unread_msg"]?.int ?? 0
                        unMessage.last_message = data["last_message"]?.string ?? ""
                        
                        Unread_messages.append(unMessage)
                    }
                    
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data / per_page) + 1
                    
                    completion(nil, Unread_messages, last_page)
                }
        }
        
    }
    
    class func LoadUserChat(page: Int = 1, frindID: Int, completion: @escaping (_ error: Error?, _ RMessages: [CMessage]?, _ last_page: Int)->Void)  {
        
        let url = URLs.loadUserChat
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,page)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "page":page,
                "friend_id":frindID,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(nil,nil,page)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    guard let dataMessages = json["properties"]["messages"].array else {
                        completion(nil,nil,page)
                        return
                    }
                    
                    var Messages = [CMessage]()
                    for data in dataMessages {
                        guard let data = data.dictionary else { return }
                        let message = CMessage()
                        message.chat_id = data["chat_id"]?.int ?? 0
                        message.user_id = data["user_id"]?.int ?? 0
                        message.avatar = data["avatar"]?.string ?? ""
                        message.name = data["name"]?.string ?? ""
                        message.message = data["message"]?.string ?? ""
                        message.type = data["type"]?.string ?? ""
                        message.file = data["file"]?.string ?? ""
                        message.seen = data["seen"]?.int ?? 0
//                        message.time = data["time"]?.string ?? ""
                        let strDate = "\(data["date"]?.string ?? "") \(data["time"]?.string ?? "")"
                        message.time = moment(strDate.timestamp).fromNow()
                        message.date = moment(strDate.timestamp).fromNow()
                        Messages.append(message)
                    }
                    let total_data = json["properties"]["total_messages"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data / per_page) + 1
                    
                    completion(nil,Messages, last_page)
                }
        }
        
    }
    
}
