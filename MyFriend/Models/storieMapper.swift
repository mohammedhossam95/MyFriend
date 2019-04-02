//
//  storieMapper.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/30/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import ObjectMapper

class RootClass: Mappable {

    
    var type: String?
    var properties: properties?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        type <- map["type"]
        properties <- map["properties"]
    }
}


class properties : Mappable{
    
    var apiVersion : String!
    var currentPage : Int!
    var data : [data]?
    var exception : String!
    var perPage : Int!
    var status : Bool!
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        currentPage <- map["current_page"]
        data <- map["data"]
        exception <- map["exception"]
        perPage <- map["per_page"]
        status <- map["status"]
        
    }
}

class data: Mappable{
    
    var avatar : String!
    var background : String!
    var background_type : String!
    var content : [content]?
    var name : String!
    var userId : Int!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        avatar <- map["avatar"]
        background <- map["background"]
        background_type <- map["background_type"]
        content <- map["content"]
        name <- map["name"]
        userId <- map["user_id"]
    }
}

class content : Mappable{
    
    var date : String!
    var file : String?
    var storyId : Int!
    var text : String!
    var time : String!
    var type : String!
    
    required init?(map: Map) {
    }
    func mapping(map: Map){
        date <- map["date"]
        file <- map["file"]
        storyId <- map["story_id"]
        text <- map["text"]
        time <- map["time"]
        type <- map["type"]
        
    }
    
}
