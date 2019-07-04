//
//  CMessage.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/2/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON

class CMessage: NSObject {

    var avatar : String = ""
    var message : String = ""
    var name : String = ""
    var chat_id : Int = 0
    var user_id : Int = 0
    var type : String = ""
    var file : String = ""
    var fileName : String = ""
    var fileType : String = ""
    var seen : Int = 0
    var date : String = ""
    var time : String = ""
    
}

/*
"chat_id": 402,
"user_id": 1,
"name": "amr",
"avatar": "uploads\/avatars\/1-avatar1546355928.jpeg",
"message": null,
"type": "video",
"file": "uploads\/chat\/usr1-chat-2019-01-02-17-43-28.mp4",
"seen": 1,
"date": "2019-01-02",
"time": "05:43 PM"
*/
