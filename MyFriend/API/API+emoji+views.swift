//
//  API+emoji+views.swift
//  MyFriend
//
//  Created by Mohammed hossam on 2/4/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ApiCalls {
    class func getMyLikes(page: Int = 1, gallery_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myLikes
        let parameters: [String : Any] =
            [
                "gallery_id":gallery_id,
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
                        let total = json["properties"]["total_liked"].int ?? 0
                        guard let dataArr = json["properties"]["likes"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstStory = RandomUser()
                            
                            firstStory.id = data["id"]?.int ?? 0
                            firstStory.userId = data["user_id"]?.int ?? 0
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0
                            firstStory.total = total
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_liked"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
    class func getMyKisses(page: Int = 1, gallery_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myLikes
        let parameters: [String : Any] =
            [
                "gallery_id":gallery_id,
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
                        let total = json["properties"]["total_love"].int ?? 0
                        guard let dataArr = json["properties"]["love"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstStory = RandomUser()
                            
                            firstStory.id = data["id"]?.int ?? 0
                            firstStory.userId = data["user_id"]?.int ?? 0
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0
                            firstStory.total = total
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_love"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
     //get my Wows
    class func getMyWows(page: Int = 1, gallery_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myLikes
        let parameters: [String : Any] =
            [
                "gallery_id":gallery_id,
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
                        let total = json["properties"]["total_wow"].int ?? 0
                        guard let dataArr = json["properties"]["wow"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstStory = RandomUser()
                            
                            firstStory.id = data["id"]?.int ?? 0
                            firstStory.userId = data["user_id"]?.int ?? 0
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0
                            firstStory.total = total
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_wow"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
    //get my Wows
    class func getMyViews(page: Int = 1, gallery_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myViews
        print(url)
        print(gallery_id)
        let parameters: [String : Any] =
            [
                "gallery_id":gallery_id,
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
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0
                            
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_wow"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
    
    //comments
    class func getMyComments(page: Int = 1, gallery_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [Comment]?, _ last_page: Int)->Void){
        let url = URLs.myComments
        let parameters: [String : Any] =
            [
                "gallery_id":gallery_id,
                "page":page,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil,page)
                    print("Comment Api \(error)")
                case .success(let value):
                    
                    var posts = [Comment]()
                    let json = JSON(value)
                    let status = json["properties"]["status"].string ?? ""
                    if status == "true"{
                        guard let dataArr = json["properties"]["data"].array else {
                            completion(nil, nil,page)
                            return
                        }
                        
                        for data in dataArr {
                            guard let data = data.dictionary else { return }
                            let firstStory = Comment()
                            
                            firstStory.id = data["id"]?.int ?? 0
                            firstStory.userId = data["user_id"]?.int ?? 0
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.comment = data["comment"]?.string ?? ""
                            firstStory.fileType = data["fileType"]?.string ?? ""
                            firstStory.fileName = data["fileName"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0

                            posts.append(firstStory)
                        }
                    }else{
                        posts.removeAll()
                        let exception = json["properties"]["exception"].string ?? ""
                        print("Comment \(exception)")
                    }
                    
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
    
    ///Story views
    //get my Wows
    class func getStoryViews(page: Int = 1, story_id: Int,   completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.myStoryViews
        let parameters: [String : Any] =
            [
                "story_id":story_id,
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
                            firstStory.avatar = data["avatar"]?.string ?? ""
                            firstStory.date = data["date"]?.string ?? ""
                            firstStory.time = data["time"]?.string ?? ""
                            firstStory.online = data["online"]?.int ?? 0
                            firstStory.verified = data["verified"]?.int ?? 0
                            
                            posts.append(firstStory)
                        }
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    
                    let total_data = json["properties"]["total_wow"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, posts,last_page)
                    
                }
        }
        
    }
}
