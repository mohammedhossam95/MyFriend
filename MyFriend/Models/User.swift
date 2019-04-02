//
//  User.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class Comment: NSObject {

    var id : Int = 0
    var gallery_id = 0
    var userId : Int = 0
    var avatar : String = ""
    var name : String = ""
    var verified : Int = 0
    var online : Int = 0
    var comment : String = ""
    var fileType : String = ""
    var fileName : String = ""
    var date : String = ""
    var time : String = ""
    var status : Bool = false
    var exception : String = ""
    
}

class RandomUser: NSObject {
    
    var id : Int = 0
    var userId : Int = 0
    var avatar : String = ""
    var name : String = ""
    var hasLiked : Bool = false
    var hasLoved : Bool = false
    var hasWowed : Bool = false
    var galleryFile : String = ""
    var type : String = ""
    var text : String = ""
    var date : String = ""
    var time : String = ""
    var liked : Int = 0
    var love : Int = 0
    var wow : Int = 0
    var online : Int = 0
    var total : Int = 0
    var verified : Int = 0
}

/*
    "id": 287,
    "user_id": 48,
    "avatar": "uploads/assets/profile.png",
    "name": "ahmed sayed",
    "hasLiked": "false",
    "hasLoved": "false",
    "hasWowed": "false",
    "gallery_file": "uploads/gallery/usr48_gallery_2018-12-25-15-33-20.jpeg",
    "type": "image",
    "text": null,
    "liked": 0,
    "love": 0,
    "wow": 0
 */
    

