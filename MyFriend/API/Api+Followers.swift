//
//  Api+Followers.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/19/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension ApiCalls{
    
    class func getfolloewrs(page: Int = 1, completion: @escaping (_ error: Error?, _ followers: [Follower]?, _ last_page: Int)->Void)  {
        let url = URLs.listUserFollowers
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
                    var followers = [Follower]()
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstPost = Follower()
                        
                        firstPost.userId = data["user_id"]?.int ?? 0
                        firstPost.avatar = data["avatar"]?.string ?? ""
                        firstPost.name = data["name"]?.string ?? ""
                        firstPost.background = data["background"]?.string ?? ""
                        firstPost.gender = data["gender"]?.string ?? ""
                        firstPost.age = data["age"]?.int ?? 0
                        firstPost.followers = data["followers"]?.int ?? 0
                        firstPost.online = data["online"]?.int ?? 0
                        firstPost.verified = data["verified"]?.int ?? 0
                        
                        followers.append(firstPost)
                    }
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, followers, last_page)
                    
                }
        }
        
    }
    class func sendConfirm (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.sendConfirm
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "request_id":friend_id,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
    class func sendReject (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.sendRegect
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "request_id":friend_id,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
    
    class func sendfollow (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.sendFollow
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "follow_action": 1,
                "friend_id":friend_id,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
    class func block( friend_id: Int, completion: @escaping (_ error: Error?, _ status: String, _ success: Bool)->Void)  {
        let url = URLs.sendFollow
        guard let user_token = helper.getApiToken() else {
            completion(nil,"",false)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "follow_action":2,
                "friend_id":friend_id,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,"",false)
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil, exception1,true )
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,exception1,false)
                    }
                    
                }
        }
    }

class func getMyFollowers(page: Int = 1, completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
    let url = URLs.myFollwers
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
                
                var posts = [RandomUser]()
                let json = JSON(value)
                let status = json["properties"]["status"].string ?? ""
                if status == "true"{
                    guard let dataArr = json["properties"]["data"].array else {
                        completion(nil, nil,page)
                        return
                    }
                    
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstStory = RandomUser()
                        
                        firstStory.id = data["id"]?.int ?? 0
                        firstStory.userId = data["user_id"]?.int ?? 0
                        firstStory.name = data["name"]?.string ?? ""
                        firstStory.type = data["type"]?.string ?? ""
                        firstStory.text = data["text"]?.string ?? ""
                        firstStory.avatar = data["avatar"]?.string ?? ""
                        firstStory.galleryFile = data["gallery_file"]?.string ?? ""
                        firstStory.liked = data["liked"]?.int ?? 0
                        firstStory.wow = data["wow"]?.int ?? 0
                        firstStory.love = data["love"]?.int ?? 0
                        
                        posts.append(firstStory)
                    }
                }else{
                    let exception = json["properties"]["exception"].string ?? ""
                    print(exception)
                }
                
                let total_data = json["properties"]["total_data"].int ?? 1
                let per_page = json["properties"]["per_page"].int ?? 1
                let last_page = (total_data/per_page)+1
                completion(nil, posts,last_page)
                
            }
    }
    
}
    
    class func getMyFollowing(page: Int = 1, completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myFollwing
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
                    
                    var posts = [RandomUser]()
                    let json = JSON(value)
                    let status = json["properties"]["status"].string ?? ""
                    if status == "true"{
                        guard let dataArr = json["properties"]["data"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstStory = RandomUser()
                            
                            firstStory.id = data["id"]?.int ?? 0
                            firstStory.userId = data["user_id"]?.int ?? 0
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.type = data["type"]?.string ?? ""
                            firstStory.text = data["text"]?.string ?? ""
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.galleryFile = data["gallery_file"]?.string ?? ""
                            firstStory.liked = data["liked"]?.int ?? 0
                            firstStory.wow = data["wow"]?.int ?? 0
                            firstStory.love = data["love"]?.int ?? 0
                            
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
    
    class func sendFollowback (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.sendFollowback
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "request_id":friend_id,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
    
   
    class func sendRequested (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.sendRequested
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "friend_id":friend_id,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
    class func sendBlock (friend_id: Int, completion: @escaping (_ error: Error?, _ success: Bool, _ status: String)->Void)  {
        let url = URLs.block
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "friend_id":friend_id,
                "type":1,
                "api_password":URLs.api_password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if let status = json["properties"]["status"].bool,status == true {
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,true,exception1)
                    }else{
                        let exception1 = json["properties"]["exception"].string ?? ""
                        completion(nil,false,exception1)
                    }
                    
                }
        }
        
    }
}
