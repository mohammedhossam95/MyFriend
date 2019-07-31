//
//  Api+Extension.swift
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
    
    class func getGallery(page: Int = 1, completion: @escaping (_ error: Error?, _ GPhotos: [GPhoto]?, _ last_page: Int)->Void)  {
        let url = URLs.userProfileGallery
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
                    
                    guard let dataArr = json["properties"]["gallery"].array else {
                        completion(nil, nil,page)
                        return
                    }
                    var GPhotos = [GPhoto]()
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstPost = GPhoto()
                        firstPost.id = data["id"]?.int ?? 0
                        firstPost.file = data["file"]?.string ?? ""
                        firstPost.type = data["type"]?.string ?? ""
                        firstPost.liked = data["liked"]?.int ?? 0
                        firstPost.love = data["love"]?.int ?? 0
                        firstPost.wow = data["wow"]?.int ?? 0
                        
                        GPhotos.append(firstPost)//properties
                    }
                    let total_data = json["properties"]["total_gallery"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, GPhotos, last_page)
                    
                }
        }
        
    }
    
    
    class func getFriendGallery(page: Int = 1, friend_id: Int, completion: @escaping (_ error: Error?, _ GPhotos: [GPhoto]?, _ last_page: Int)->Void)  {
        let url = URLs.userFriendProfileGallery
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,page)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "friend_id":friend_id,
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
                    guard let dataArr = json["properties"]["gallery"].array else {
                        completion(nil, nil,page)
                        return
                    }
                    var GPhotos = [GPhoto]()
                    for data in dataArr {
                        guard let data = data.dictionary else { return }
                        let firstPost = GPhoto()
                        firstPost.id = data["id"]?.int ?? 0
                        firstPost.file = data["file"]?.string ?? ""
                        firstPost.type = data["type"]?.string ?? ""
                        firstPost.liked = data["liked"]?.int ?? 0
                        firstPost.love = data["love"]?.int ?? 0
                        firstPost.wow = data["wow"]?.int ?? 0
                        
                        GPhotos.append(firstPost)//properties
                    }
                    let total_data = json["properties"]["total_gallery"].int ?? 1
                    let per_page = json["properties"]["per_page"].int ?? 1
                    let last_page = (total_data/per_page)+1
                    completion(nil, GPhotos, last_page)
                    
                }
        }
        
    }
    //MARK: upload Photo
    
    class func uploadPhoto(file: UIImage, completion: @escaping (_ error: Error?, _ GPhoto: GPhoto?)->Void)  {
        
        guard let user_token = helper.getApiToken() else {
            return
        }
        
        let url = URLs.uploadPhoto
        //let url = URLs.uploadPhoto + "?api_password\(URLs.api_password)" + "?user_token\(user_token)"
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
            
            
            for (key, value) in parameters {
                form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = file.jpegData(compressionQuality: 0.5){
                form.append(data, withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil)
        { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                print("The Error is \(error)")
                completion(error,nil)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: { (progress: Progress) in
                    print(progress)
                }).responseJSON { (response) in
                        switch response.result
                        {
                        case .failure(let error):
                            completion(error,nil)
                            print("0000000uploading Error \(error)")
                        case .success(let value):
                            let json = JSON(value)
                            if let status = json["properties"]["status"].string, status == "true" {
                                guard let dataArr = json["properties"]["gallery"].array else {
                                    completion(nil, nil)
                                    return
                                }
                                let photo = GPhoto()
                                photo.id = dataArr[0]["id"].int ?? 0
                                photo.file = dataArr[0]["file"].string ?? ""
                                photo.type = dataArr[0]["type"].string ?? ""
                                photo.liked = dataArr[0]["liked"].int ?? 0
                                photo.love = dataArr[0]["love"].int ?? 0
                                photo.wow = dataArr[0]["wow"].int ?? 0
                                
                                
                                completion(nil, photo)
                                
                            }else {
                                print("Upload failure")
                                completion(nil,nil)
                            }
                        }
                    }
            }
            
        }
        
    }
    //MARK: Video
    class func uploadVideo(file: URL, completion: @escaping (_ error: Error?, _ GPhoto: GPhoto?)->Void)  {
        
        guard let user_token = helper.getApiToken() else {
            return
        }
        
        let url = URLs.uploadPhoto
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.upload(multipartFormData: { form in
            
            for (key, value) in parameters {
                form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            do {
                let data = try Data(contentsOf: file)
                form.append(data, withName: "file", fileName: "\(Date().timeIntervalSince1970).mov", mimeType: "video/quicktime")
            } catch  {
                print("Video Not Allowed")
            }
            
        }, to: url)
        { (result) in
            switch result {
            case .success(request: let upload, _, _):
                upload.uploadProgress(closure: { (progress: Progress) in
                    print(progress)
                })
                upload.responseJSON { response in
                    switch response.result
                    {
                    case .failure(let error):
                        completion(error,nil)
                    case .success(let value):
                        let json = JSON(value)
                        print("json",json)
                        if let status = json["properties"]["status"].string, status == "true" {
                            guard let dataArr = json["properties"]["gallery"].array else {
                                completion(nil, nil)
                                return
                            }
                            let photo = GPhoto()
                            photo.id = dataArr[0]["id"].int ?? 0
                            photo.file = dataArr[0]["file"].string ?? ""
                            photo.type = dataArr[0]["type"].string ?? ""
                            photo.liked = dataArr[0]["liked"].int ?? 0
                            photo.love = dataArr[0]["love"].int ?? 0
                            photo.wow = dataArr[0]["wow"].int ?? 0
                            
                            
                            completion(nil, photo)
                            
                        }else {
                            print("Upload failure")
                            completion(nil,nil)
                        }
                    }
                }
            case .failure(let error):
                completion(error,nil)
            }
            
        }
        
    }
    
    // single gallery
    class func getSinglePhoto(gallery_id: Int, completion: @escaping (_ error: Error?, _ singleGallery: SingleGallery?)->Void)  {
        let url = URLs.singlePhoto
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil)
            return
        }
        let parameters: [String: Any] =
            [
                "gallery_id":gallery_id,
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
                    
                    let firstPost = SingleGallery()
                    let json = JSON(value)
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        //  print(userData)
                        firstPost.file = json["properties"]["gallery"]["file"].string ?? ""
                        firstPost.galleryId = json["properties"]["gallery"]["gallery_id"].int ?? 0
                        firstPost.hasLiked = json["properties"]["gallery"]["hasLiked"].string ?? "false"
                        firstPost.hasLoved = json["properties"]["gallery"]["hasLoved"].string ?? "false"
                        firstPost.hasWowed = json["properties"]["gallery"]["hasWowed"].string ?? "false"
                        firstPost.liked = json["properties"]["gallery"]["liked"].int ?? 0
                        firstPost.love = json["properties"]["gallery"]["love"].int ?? 0
                        firstPost.wow = json["properties"]["gallery"]["wow"].int ?? 0
                        firstPost.type = json["properties"]["gallery"]["type"].string ?? ""
                        firstPost.totalComments = json["properties"]["total_comments"].int ?? 0
                        firstPost.viewersCount = json["properties"]["viewersCount"].int ?? 0
                        
                        //                        if let userData = json["properties"]["gallery"].array,userData.count > 0{
                        //                            //  print(userData)
                        //                            firstPost.file = userData[0]["file"].string ?? ""
                        //                            firstPost.galleryId = userData[0]["gallery_id"].int ?? 0
                        //                            firstPost.hasLiked = userData[0]["hasLiked"].string ?? "false"
                        //                            firstPost.hasLoved = userData[0]["hasLoved"].string ?? "false"
                        //                            firstPost.hasWowed = userData[0]["hasWowed"].string ?? "false"
                        //                            firstPost.liked = userData[0]["liked"].int ?? 0
                        //                            firstPost.love = userData[0]["love"].int ?? 0
                        //                            firstPost.wow = userData[0]["wow"].int ?? 0
                        //                            firstPost.type = userData[0]["type"].string ?? ""
                        //                            firstPost.totalComments = json["properties"]["total_comments"].int ?? 0
                        //                            firstPost.viewersCount = json["properties"]["viewersCount"].int ?? 0
                        //                        }
                        completion(nil, firstPost)
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("Single Gallery  \(exception)")
                        completion(nil,nil)
                    }
                    
                }
        }
    }
    
}
