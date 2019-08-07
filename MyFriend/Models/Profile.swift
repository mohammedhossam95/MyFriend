//
//  Profile.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var user_id: Int = 0
    var avatar : String = ""
    var username : String = ""
    var age : Int = 0
    var gender : String = ""
    var online : Int = 0
    var verified : Int = 0
    var followers : Int = 0
    var following : Int = 0
    var privateAc : Bool = false
    var caseSt : Int = 0
    var case_name : String = ""
    var bio : String = ""
    var work : String = ""
    var interest_in : String = ""
    var hobbies = [String]()
}


class infoProfile: NSObject {

    var avatar : String = ""
    var name : String = ""
    var birthdate : String = ""
    var gender : String = ""
    var interest_in : String = ""
    var bio : String = ""
    var work : String = ""
    var hobbies: [String] = []
}
