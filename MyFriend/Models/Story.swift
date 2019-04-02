//
//  Story.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class Story: NSObject {
    
    var story_id : Int = 0
    var userId : Int = 0
    var avatar : String = ""
    var name : String = ""
    var file : String = ""
    var text : String = ""
    var views : Int = 0
    var type : String = ""
    var date : String = ""
    var time : String = ""
    var background :String = ""
    
  //  var contents : [storyContent] = []
    
}

class storyContent {
    var type: String = ""
    var url: String = ""
}

/*
"story_id": 177,
"user_id": 1,
"avatar": "uploads/avatars/1-avatar1545321770.jpeg",
"name": "amr shaban",
"file": "uploads/stories/usr1_stories_text_2018-12-25-13-38-40.png",
"text": "story from amr",
"type": "text",
"views": 0,
"date": "2018-12-25",
"time": "01:38 PM"
*/

