//
//  unReadMessage.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/19/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON

class unReadMessage: NSObject {
    
    var avatar : String = ""
    var count_unread_msg : Int = 0
    var user_id: Int = 0
    var last_message : String = ""
    var last_message_icon : String = ""
    var name : String = ""
    var verified : Int = 0
    var online : Int = 0
    var seen : Int = 0
    var created_at : String = ""
}
