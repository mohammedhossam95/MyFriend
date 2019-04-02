//
//  post.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON

class Post: NSObject {
    
    var avatar : String
    var date : String
    var followers : Int
    var galleryFile : String
    var hasLiked : Bool
    var hasLoved : Bool
    var hasWowed : Bool
    var id : Int
    var liked : Int
    var love : Int
    var name : String
    var time : String
    var type : String
    var userId : Int
    var wow : Int
    
    init?(dict: [String: JSON]){
        
        guard let avatar = dict["avatar"]?.string, let date = dict["date"]?.string, let followers = dict["followers"]?.int, let galleryFile = dict["gallery_file"]?.string, let hasLiked = dict["hasLiked"]?.bool,let hasLoved = dict["hasLoved"]?.bool, let hasWowed = dict["hasWowed"]?.bool, let userId = dict["user_id"]?.int,let id = dict["id"]?.int,let name = dict["name"]?.string, let liked = dict["liked"]?.int, let love = dict["love"]?.int, let wow = dict["wow"]?.int, let time = dict["time"]?.string, let type = dict["type"]?.string  else { return nil }
        

        self.avatar = avatar
        self.date = date
        self.galleryFile = galleryFile
        self.followers = followers
        self.hasLiked = hasLiked
        self.hasLoved = hasLoved
        self.hasWowed = hasWowed
        self.liked = liked
        self.love = love
        self.wow = wow
        self.id = id
        self.userId = userId
        self.name = name
        self.type = type
        self.time = time
        
    }
    
}

