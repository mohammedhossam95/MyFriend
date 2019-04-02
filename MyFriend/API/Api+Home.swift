//
//  Api+Home.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

extension ApiCalls{
    
    class func getPosts(page: Int = 1, completion: @escaping (_ error: Error?, _ posts: [HomePost]?, _ last_page: Int)->Void)  {
        let url = URLs.homePosts
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
                    print("mokmok")
                    print(error)
                case .success(let value):
                    
                    var posts = [HomePost]()
                    let json = JSON(value)
                    _ = json["properties"]["status"].string ?? ""
                    let exception = json["properties"]["exception"].string ?? ""
                    
                    if exception != "user_token not exists" {
                        guard let dataArr = json["properties"]["data"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstPost = HomePost()
                            firstPost.name = data["name"]?.string ?? ""
                            firstPost.time = data["time"]?.string ?? ""
                            firstPost.type = data["type"]?.string ?? ""
                            firstPost.avatar = data["avatar"]?.string ?? ""
                            firstPost.galleryFile = data["gallery_file"]?.string ?? ""
                            firstPost.userId = data["user_id"]?.int ?? 0
                            firstPost.liked = data["liked"]?.int ?? 0
                            firstPost.love = data["love"]?.int ?? 0
                            firstPost.wow = data["wow"]?.int ?? 0
                            firstPost.hasLiked = data["hasLiked"]?.string ?? ""
                            firstPost.hasLoved = data["hasLoved"]?.string ?? ""
                            firstPost.hasWowed = data["hasWowed"]?.string ?? ""
                            firstPost.hasStroy = data["hasStroy"]?.string ?? ""
                            firstPost.text = data["text"]?.string ?? ""
                            firstPost.id = data["id"]?.int ?? 0
                            firstPost.comments = data["comments"]?.int ?? 0
                            firstPost.views = data["views"]?.int ?? 0
                            firstPost.verified = data["verified"]?.int ?? 0
                            firstPost.online = data["online"]?.int ?? 0
                            
                            
                            posts.append(firstPost)
                        }
                    }else{
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                        let redViewController = mainStoryBoard.instantiateInitialViewController()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = redViewController
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
    
    class func getStories(page: Int = 1, completion: @escaping (_ error: Error?, _ story: RootClass?, _ last_page: Int)->Void)  {
        let url = URLs.homeStories
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,page)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "friend_id": 0,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil,page)
                case .success(let value):
                    let model = Mapper<RootClass>().map(JSONObject: value)
                    let last_page = page
                    completion(nil,model, last_page)
                    
                }
        }
    }
    
    class func sendTextStory(text: String,bgcolor: String, completion: @escaping (_ error: Error?, _ success: Bool, _ file: String)->Void)  {
        let url = URLs.sendTextStoryUrl
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        let parameters: [String: Any] =
            [
                
                "text": text,
                "bgcolor": bgcolor,
                "type":"text",
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        
                        let exception = json["properties"]["exception"].string ?? ""
                        print("send Text story  \(exception)")
                        if let userData = json["properties"]["data"].array,userData.count > 0{
                            //  print(userData)
                            guard let file = userData[0]["file"].string else {
                                return
                            }
                            
                            completion(nil, true,file)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("False status send Text story  \(exception)")
                        completion(nil,false, "")
                    }
                    
                }
                
        }
        
    }
    //report and delete post
    class func getMyStories(page: Int = 1, completion: @escaping (_ error: Error?, _ randomImages: [HomePost]?, _ last_page: Int)->Void){
        let url = URLs.getMyStories
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
                    
                    var posts = [HomePost]()
                    let json = JSON(value)
                    let status = json["properties"]["status"].string ?? ""
                    if status == "true"{
                        guard let dataArr = json["properties"]["data"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstPost = HomePost()
                            
                            firstPost.id = data["story_id"]?.int ?? 0
                            firstPost.type = data["type"]?.string ?? ""
                            firstPost.galleryFile = data["file"]?.string ?? ""
                            firstPost.views = data["views"]?.int ?? 0
                            
                            posts.append(firstPost)
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
    
    class func DeleteStory(story: HomePost, completion: @escaping (_ error: Error?, _ success: Bool, _ file: String)->Void)  {
        let url = URLs.deleteStory
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        let parameters: [String: Any] =
            [
                "story_id": story.id,
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        
                        let exception = json["properties"]["exception"].string ?? ""
                        completion(nil, true,exception)
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("False status send Text story  \(exception)")
                        completion(nil,false, "")
                    }
                    
                }
                
        }
        
    }
    class func DeleteGallery(photo: GPhoto, completion: @escaping (_ error: Error?, _ success: Bool, _ file: String)->Void)  {
        let url = URLs.deletePhoto
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        let parameters: [String: Any] =
            [
                "gallery_id": photo.id,
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                    print(error)
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        
                        let exception = json["properties"]["exception"].string ?? ""
                        completion(nil, true,exception)
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("False status send Text story  \(exception)")
                        completion(nil,false, "")
                    }
                    
                }
        }
    }
    class func ReportGallery(post: HomePost, reason: String, completion: @escaping (_ error: Error?, _ success: Bool, _ file: String)->Void)  {
        let url = URLs.reportPost
        guard let user_token = helper.getApiToken() else {
            completion(nil,false,"")
            return
        }
        let parameters: [String: Any] =
            [
                "gallery_id": post.id,
                "reason": reason,
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,"")
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        let exception = json["properties"]["exception"].string ?? ""
                        completion(nil, true, exception)
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("False status send Text story  \(exception)")
                        completion(nil,false, exception)
                    }
                    
                }
        }
    }
}
