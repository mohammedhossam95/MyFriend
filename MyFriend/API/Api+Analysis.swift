//
//  Api+Analysis.swift
//  MyFriend
//
//  Created by Mohammed Hossam on 2/25/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ApiCalls {
    
    class func GetTodayAnalysis(report_type: Int = 1,  completion: @escaping (_ error: Error?, _ insight: [Insight]? ,  _ followRatio: [FollowRatio]?,  _ AgeGroup_profile: [AgeGroup]?, _ AgeGroup_follow: [AgeGroup]? )->Void){
        let url = URLs.analysis
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,nil,nil,nil)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "report_type":report_type,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil,nil,nil,nil)
                    print(error)
                case .success(let value):
                    
                    var posts = [Insight]()
                    var follows = [FollowRatio]()
                    var AgeGroup_profile = [AgeGroup]()
                    var AgeGroup_follow = [AgeGroup]()
                    
                    let json = JSON(value)
                    let status = json["properties"]["status"].string ?? ""
                    if status == "true"{
//***********************************
                        guard let insights = json["properties"]["insight"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in insights {
                            guard let data = data.dictionary else { return }
                            let firstStory = Insight()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.benefits = data["benefits"]?.string ?? ""
                            posts.append(firstStory)
                        }
//***********************************
                        guard let followRatio = json["properties"]["wowRatio"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in followRatio {
                            guard let data = data.dictionary else { return }
                            let firstStory = FollowRatio()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.wows = data["value"]?.int ?? 0
                            firstStory.profilesviews = data["profiles views"]?.int ?? 0
                            firstStory.totalBar = data["total_bar"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            follows.append(firstStory)

                        }
//***********************************
                        guard let ageGroup_profiles = json["properties"]["ageGroup_profiles"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in ageGroup_profiles {
                            guard let data = data.dictionary else { return }
                            let firstStory = AgeGroup()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            AgeGroup_profile.append(firstStory)
                        }
//***********************************
                        guard let ageGroup_wow = json["properties"]["ageGroup_wow"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in ageGroup_wow {
                            guard let data = data.dictionary else { return }
                            let firstStory = AgeGroup()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            AgeGroup_follow.append(firstStory)
                        }
//***********************************
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    completion(nil, posts,follows,AgeGroup_profile,AgeGroup_follow)
                    
                }
        }
        
    }
    
    //**************************** Month Analysis **********************
    
    class func GetMonthAnalysis(report_type: Int = 2,  completion: @escaping (_ error: Error?, _ insight: [Insight]? ,  _ followRatio: [FollowRatio]?,  _ AgeGroup_profile: [AgeGroup]?, _ AgeGroup_follow: [AgeGroup]? )->Void){
        let url = URLs.analysis
        guard let user_token = helper.getApiToken() else {
            completion(nil,nil,nil,nil,nil)
            return
        }
        let parameters: [String : Any] =
            [
                "user_token":user_token,
                "report_type":report_type,
                "api_password":URLs.api_password
        ]
        Alamofire.request(url, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { response in
                switch response.result
                {
                case .failure(let error):
                    completion(error,nil,nil,nil,nil)
                    print(error)
                case .success(let value):
                    
                    var posts = [Insight]()
                    var follows = [FollowRatio]()
                    var AgeGroup_profile = [AgeGroup]()
                    var AgeGroup_follow = [AgeGroup]()
                    
                    let json = JSON(value)
                    let status = json["properties"]["status"].string ?? ""
                    if status == "true"{
                        //***********************************
                        guard let insights = json["properties"]["insight"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in insights {
                            guard let data = data.dictionary else { return }
                            let firstStory = Insight()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.benefits = data["benefits"]?.string ?? ""
                            posts.append(firstStory)
                        }
                        //***********************************
                        guard let followRatio = json["properties"]["wowRatio"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in followRatio {
                            guard let data = data.dictionary else { return }
                            let firstStory = FollowRatio()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.wows = data["value"]?.int ?? 0
                            firstStory.profilesviews = data["profiles views"]?.int ?? 0
                            firstStory.totalBar = data["total_bar"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            follows.append(firstStory)
                            
                        }
                        //***********************************
                        guard let ageGroup_profiles = json["properties"]["ageGroup_profiles"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in ageGroup_profiles {
                            guard let data = data.dictionary else { return }
                            let firstStory = AgeGroup()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            AgeGroup_profile.append(firstStory)
                        }
                        //***********************************
                        guard let ageGroup_wow = json["properties"]["ageGroup_wow"].array else {
                            completion(nil, nil,nil,nil,nil)
                            return
                        }
                        for data in ageGroup_wow {
                            guard let data = data.dictionary else { return }
                            let firstStory = AgeGroup()
                            firstStory.name = data["name"]?.string ?? ""
                            firstStory.value = data["value"]?.int ?? 0
                            firstStory.percent = data["percent"]?.string ?? ""
                            AgeGroup_follow.append(firstStory)
                        }
                        //***********************************
                    }else{
                        let exception = json["properties"]["exception"].string ?? ""
                        print(exception)
                    }
                    completion(nil, posts,follows,AgeGroup_profile,AgeGroup_follow)
                    
                }
        }
        
    }
}
