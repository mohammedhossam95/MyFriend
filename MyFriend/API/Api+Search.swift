//
//  Api+Search.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ApiCalls{
    
    class func randomSearch(page: Int = 1, completion: @escaping (_ error: Error?, _ randomImages: [RandomUser]?, _ last_page: Int)->Void){
        let url = URLs.randomSearch
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
    class func getSearchResults(page: Int = 1, search: String, completion: @escaping (_ error: Error?, _ users: [RandomUser]?, _ last_page: Int)->Void)  {
        let url = URLs.Search
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,page)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "page":page,
                "search":search,
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
                    var users = [RandomUser]()
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstPost = RandomUser()
                        firstPost.name = data["name"]?.string ?? ""
                        firstPost.avatar = data["avatar"]?.string ?? ""
                        firstPost.userId = data["user_id"]?.int ?? 0
                        
                        users.append(firstPost)
                    }
                    let total_data = json["properties"]["total_data"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, users, last_page)
                    
                }
        }
        
    }
}
