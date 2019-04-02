//
//  Api+Profile.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

extension ApiCalls{
    
    //Mark :- Account Profile
    
    class func getProfile(completion: @escaping (_ error: Error?, _ profile: Profile?)->Void)  {
        let url = URLs.userProfile
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
                    //var profile = Profile()
                    // guard let data = dataArr[0].dictionary else { return }
                    
                    let firstPost = Profile()
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        if let dataArr = json["properties"]["data"].array,dataArr.count > 0{
                            
                            firstPost.username = dataArr[0]["username"].string ?? ""
                            firstPost.avatar = dataArr[0]["avatar"].string ?? ""
                            firstPost.age = dataArr[0]["age"].int ?? 0
                            firstPost.gender = dataArr[0]["gender"].string ?? ""
                            firstPost.online = dataArr[0]["online"].int ?? 0
                            firstPost.verified = dataArr[0]["verified"].int ?? 0
                            firstPost.followers = dataArr[0]["followers"].int ?? 0
                            firstPost.following = dataArr[0]["following"].int ?? 0
                            firstPost.user_id = dataArr[0]["user_id"].int ?? 0
                            firstPost.bio = dataArr[0]["bio"].string ?? ""
                            firstPost.work = dataArr[0]["work"].string ?? ""
                            firstPost.interest_in = dataArr[0]["interest_in"].string ?? ""
                            
                        }
                        
                        guard let userHobbies = json["properties"]["hobbies"].array,userHobbies.count > 0 else {
                            completion(nil, firstPost)
                            return
                        }
                        
                        for data in userHobbies {
                            guard let data = data.dictionary else { return }
                            
                            let hobbie = data["hobbie"]?.string ?? ""
                            firstPost.hobbies += "  \(hobbie)  "
                            
                        }
                        
                        completion(nil, firstPost)
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("My profile   \(exception)")
                        completion(nil,nil)
                    }
                    
                    
                }
        }
        
    }
    
    //Mark :- Account Profile
    
    class func getUserProfile(friend_id: Int, completion: @escaping (_ error: Error?, _ profile: Profile?)->Void)  {
        let url = URLs.friendProfile
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil)
            return
        }
        let parameters: [String: Any] =
            [
                "friend_id":friend_id,
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
                    
                    let firstPost = Profile()
                    let json = JSON(value)
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        if let userData = json["properties"]["data"].array,userData.count > 0{
                            //  print(userData)
                            firstPost.username = userData[0]["username"].string ?? ""
                            firstPost.avatar = userData[0]["avatar"].string ?? ""
                            firstPost.age = userData[0]["age"].int ?? 0
                            firstPost.gender = userData[0]["gender"].string ?? ""
                            firstPost.online = userData[0]["online"].int ?? 0
                            firstPost.followers = userData[0]["followers"].int ?? 0
                            firstPost.following = userData[0]["following"].int ?? 0
                            firstPost.caseSt = userData[0]["case"].int ?? 0
                            firstPost.privateAc = userData[0]["private"].bool ?? false
                            firstPost.case_name = userData[0]["case_name"].string ?? ""
                            firstPost.bio = userData[0]["bio"].string ?? ""
                            firstPost.work = userData[0]["work"].string ?? ""
                            firstPost.verified = userData[0]["verified"].int ?? 0
                            firstPost.interest_in = userData[0]["interest_in"].string ?? ""
                            
                        }
                        guard let userHobbies = json["properties"]["hobbies"].array,userHobbies.count > 0 else {
                            completion(nil, firstPost)
                            return
                        }
                        
                        for data in userHobbies {
                            guard let data = data.dictionary else { return }
                            
                            let hobbie = data["hobbie"]?.string ?? ""
                            firstPost.hobbies += "  \(hobbie)  "
                            
                        }
                        
                        completion(nil, firstPost)
                        
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("user friend  \(exception)")
                        completion(nil,nil)
                    }
                    
                }
                
        }
        
    }
    
    //Mark :- Account Profile
    
    class func getUserInfo( completion: @escaping (_ error: Error?, _ profile: infoProfile?)->Void)  {
        let url = URLs.info
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil)
            return
        }
        let parameters: [String: Any] =
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
                    
                    let firstPost = infoProfile()
                    let json = JSON(value)
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        if let userData = json["properties"]["data"].array,userData.count > 0{
                            //  print(userData)
                            firstPost.name = userData[0]["name"].string ?? ""
                            firstPost.avatar = userData[0]["avatar"].string ?? ""
                            firstPost.birthdate = userData[0]["birthdate"].string ?? ""
                            firstPost.gender = userData[0]["gender"].string ?? ""
                            firstPost.bio = userData[0]["bio"].string ?? ""
                            firstPost.work = userData[0]["work"].string ?? ""
                            firstPost.interest_in = userData[0]["interest_in"].string ?? ""
                            
                        }
                        guard let userHobbies = json["properties"]["hobbies"].array,userHobbies.count > 0 else {
                            completion(nil, firstPost)
                            return
                        }
                        
                        for data in userHobbies {
                            guard let data = data.dictionary else { return }
                            
                            let hobbie = data["hobbie"]?.string ?? ""
                            firstPost.hobbies += "  \(hobbie)  "
                        }
                        
                        completion(nil, firstPost)
                        
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("the info screen exception \(exception)")
                        completion(nil,nil)
                    }
                    
                }
                
        }
        
    }
    class func updateuserInfo(username: String,birthdate: String,gender: String,interest_in: String,bio: String,work: String,hobbies: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void)  {
        let url = URLs.editInfo
        guard let user_token = helper.getApiToken() else {
            completion(nil,false)
            return
        }
        let parameters: [String: Any] =
            [
                "username": username,
                "birthdate": birthdate,
                "gender": gender,
                "interest_in": interest_in,
                "bio": bio,
                "work": work,
                "hobbies": hobbies,
                "user_token":user_token,
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
                    
                    if let status = json["properties"]["status"].string,status ==  "true"{
                        
                        let exception = json["properties"]["exception"].string ?? ""
                        print("true  \(exception)")
                        
                        completion(nil, true)
                        
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print("the beb  \(exception)")
                        completion(nil,false)
                    }
                    
                }
                
        }
        
    }
    
    class func updateUserPhoto(avatar: UIImage, completion: @escaping (_ error: Error?, _ success: Bool)->Void)  {
        
        guard let user_token = helper.getApiToken() else {
            return
        }
        
        let url = URLs.updatePhoto
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
            
            
            for (key, value) in parameters {
                form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = avatar.jpegData(compressionQuality: 0.5){
                form.append(data, withName: "avatar", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil)
        { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                print("The Error in updating photo is \(error)")
                completion(error,false)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: { (progress: Progress) in
                    print(progress)
                })
                    .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        switch response.result
                        {
                        case .failure(let error):
                            completion(error,false)
                            print("loading Error \(error)")
                            
                        case .success(let value):
                            let json = JSON(value)
                            if let status = json["properties"]["status"].string, status == "true" {
                                
                                if let userData = json["properties"]["data"].array,userData.count > 0{
                                    if let avatar = userData[0]["avatar"].string {
                                        helper.updateUserPhoto(avatar: avatar)
                                    }
                                }
                                let exception = json["properties"]["exception"].string ?? ""
                                print("status  \(exception)")
                                
                                completion(nil, true)
                                
                            }else {
                                let exception = json["properties"]["exception"].string ?? ""
                                print("Upload useer image failure  \(exception)")
                                completion(nil,false)
                            }
                        }
                    })
            }
            
        }
        
    }
    class func uploadGalleryVideo(avatar: URL, completion: @escaping (_ error: Error?, _ success: Bool)->Void)  {
        
        guard let user_token = helper.getApiToken() else {
            return
        }
        
        let url = URLs.uploadPhoto
        
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "api_password":URLs.api_password
        ]
        Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
            
            
            for (key, value) in parameters {
                form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            do {
                let videoData: Data = try Data(contentsOf: avatar)
                 form.append(videoData, withName: "avatar", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
            } catch let error{
                print(error.localizedDescription)
                
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil)
        { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                print("The Error in updating photo is \(error)")
                completion(error,false)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                print("video true")
                upload.uploadProgress(closure: { (progress: Progress) in
                   // print(progress)
                })
                    .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        switch response.result
                        {
                        case .failure(let error):
                            completion(error,false)
                            print("loading Error \(error)")
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            if let status = json["properties"]["status"].string, status == "true" {
                                
//                                if let userData = json["properties"]["gallery"].array,userData.count > 0{
//                                    if let avatar = userData[0]["avatar"].string {
//                                        helper.updateUserPhoto(avatar: avatar)
//                                    }
//                                }
                                let exception = json["properties"]["exception"].string ?? ""
                                print("status  \(exception)")
                                
                                completion(nil, true)
                                
                            }else {
                                let exception = json["properties"]["exception"].string ?? ""
                                print("Upload user image failure  \(exception)")
                                completion(nil,false)
                            }
                        }
                    })
            }
            
        }
        
    }
}

