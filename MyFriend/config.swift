//
//  config.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
struct URLs {

    ///server for ad`s
    //ca-app-pub-1940793456791298~8791159745
    static let YOUR_Real_ADMOB_APP_ID = "ca-app-pub-1940793456791298~8791159745"
    static let YOUR_ADMOB_APP_ID = "ca-app-pub-8501671653071605~9497926137"
    static let bannarId = "ca-app-pub-1940793456791298/2313327401"
    
    ///password  for server for all end points
    static let api_password = "Pa$$w0rds"
    
    ///Main Domain for server
    static let main = "https://www.myfriend-app.com/api/v1/"
    
    ///server for Photo
    static let photoMain = "https://www.myfriend-app.com/"
    
    static let mainSocket = "https://www.myfriend-app.com:4498"
    ///static let mainSocket = "https://www.myfriend-app.com:44499"
    
    ///Login Method -post- pararmeters api_password email or phone password
    static let login = main + "auth/login"
    
    ///Login Method -post- pararmeters api_password email or phone password
    static let register = main + "auth/signup"
    
    ///Login Method -post- pararmeters api_password email or phone password
    static let confirm = main + "auth/activation"
    
    ///forget Password Method -post- pararmeters api_password or email - phone
    static let forgetPassword = main + "auth/forget"
    
    ///reset Password Method -post- pararmeters api_password, activation_key - password or con_password
    static let resetPassword = main + "auth/reset"
    
    ///Home Posts Method -post- pararmeters api_password usertoken or page
    static let homePosts = main + "home/layout"
    
    ///Home Posts Method -post- pararmeters api_password usertoken or page
    static let sendTextStoryUrl = main + "story/createFile"
    
    ///profile Posts Method -post- pararmeters api_password usertoken or page
    static let userProfile = main + "me/profile"
    
    ///profile Posts Method -post- pararmeters api_password usertoken
    static let info = main + "me/info"
    
    ///profile Posts Method -post- pararmeters api_password usertoken
    static let editInfo = main + "me/info/edit"
    
    ///profile Posts Method -post- pararmeters api_password usertoken friend_id
    static let friendProfile = main + "friend/profile"
    
    ///profile Posts Method -post- pararmeters api_password usertoken gallery_id
    static let singlePhoto = main + "me/gallery/single"

    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let listUserChats = main + "chat/friends/list"
    
    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let listUserFollowers = main + "wow/layout"
    
    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let sendFollow = main + "wow/save"
    
    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let sendConfirm = main + "wow/requests/accept"
    
    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let sendRegect = main + "wow/requests/decline"
    
    ///sendFollowback Method -post- pararmeters api_password usertoken and request_id
    static let sendFollowback = main + "wow/requests/followBack"
    
    ///sendRequested Method -post- pararmeters api_password usertoken and friend_id
    static let sendRequested = main + "wow/destroy"
    
    ///send block Method -post- pararmeters api_password usertoken and friend_id
    static let block = main + "me/block"
    
    ///List userProfileGallery Method -post- pararmeters api_password usertoken or page
    static let userProfileGallery = main + "me/gallery"
    
    ///List userProfileGallery Method -post- pararmeters api_password usertoken or page
    static let userFriendProfileGallery = main + "me/gallery/friend"
    
    ///List userProfileGallery Method -post- pararmeters api_password usertoken or page
    static let Notification = main + "home/notifications"
    
    ///Home Get Stories collection  Method -post- pararmeters api_password usertoken or page
    static let homeStories = main + "story/preview/ios"
    
    ///Home Get Stories collection  Method -post- pararmeters api_password usertoken or page
    static let getMyStories = main + "story/my"
    
    ///Home Get Stories collection  Method -post- pararmeters api_password usertoken or page
    static let randomSearch = main + "home/search"
    
    ///Home Get Stories collection  Method -post- pararmeters api_password usertoken or page
    static let Search = main + "home/search/result"
    
    ///upload photo from gallery  Method -post- pararmeters api_password usertoken or page
    static let uploadPhoto = main + "me/gallery/create"
    
    ///upload photo from gallery  Method -post- pararmeters api_password usertoken or page
    static let updatePhoto = main + "me/info/edit/avatar"
    
    ///profile Posts Method -post- pararmeters api_password usertoken or page
    static let userSettings = main + "me/setting"

    ///profile Posts Method -post- pararmeters api_password usertoken or page
    static let updateSettings = main + "me/setting/edit"
    
    ///List user chats Method -post- pararmeters api_password usertoken or page
    static let loadUserChat = main + "chat/conversion"
    
    ///List user followers Method -post- pararmeters api_password usertoken or page
    static let myFollwers = main + "me/followers"
    
    ///List user followers Method -post- pararmeters api_password usertoken or page
    static let myLikes = main + "home/emoji"
    
    ///List user followings Method -post- pararmeters api_password usertoken or page
    static let myFollwing = main + "me/following"

    ///List user gallery views Method -post- pararmeters api_password usertoken or page
    static let myViews = main + "home/viewers"
    
    ///List user gallery views Method -post- pararmeters api_password usertoken or page
    static let myStoryViews = main + "story/viewers"
    
    ///List user comments Method -post- pararmeters api_password usertoken gallery id  or page
    static let myComments = main + "home/comments"
    
    ///delete user story Method -post- pararmeters api_password usertoken story_id  or page
    static let deleteStory = main + "story/destroy"
    
    ///delete user story Method -post- pararmeters api_password usertoken gallery_id or page
    static let deletePhoto = main + "me/gallery/destroy"
    
    ///delete user story Method -post- pararmeters api_password usertoken gallery_id reason or page
    static let reportPost = main + "me/gallery/report"
    
    ///Get profile Analysis Method -post- pararmeters api_password usertoken or report_type
    static let analysis = main + "me/report"
}

