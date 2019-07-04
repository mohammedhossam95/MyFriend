//
//  file+ana.swift
//  MyFriend
//
//  Created by Mohammed hossam on 2/26/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON

class FollowRatio : NSObject {
    var name : String = ""
    var percent : String = ""
    var profilesviews : Int = 0
    var totalBar : Int = 0
    var wows : Int = 0
}

class Insight : NSObject {
    var benefits : String = ""
    var name : String = ""
    var value : Int = 0
}

class AgeGroup : NSObject {
    var name : String = ""
    var percent : String = ""
    var value : Int = 0
}
