//
//  helper.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    class func saveApiToken(token: String)   {
        let def = UserDefaults.standard
        def.set(token, forKey: "user_token")
        def.synchronize()
        restartApp()
    }
    class func saveUserInfo(user_id: Int,username: String,avatar: String,bgGallery: String)   {
        let def = UserDefaults.standard
        def.set(user_id, forKey: "user_id")
        def.set(username, forKey: "username")
        def.set(avatar, forKey: "avatar")
        def.set(bgGallery, forKey: "bgGallery")
        def.synchronize()
    }
    
    class func updateUserPhoto(avatar: String)   {
        let def = UserDefaults.standard
        def.set(avatar, forKey: "avatar")
        def.synchronize()
    }
    
    class func getApiToken() -> String? {
        let def = UserDefaults.standard
        let token = def.object(forKey: "user_token") as? String
        return token
    }
    
    class func getUsername() -> String? {
        let def = UserDefaults.standard
        let username = def.object(forKey: "username") as? String
        return username
    }
    
    class func getUserId() -> Int? {
        let def = UserDefaults.standard
        let user_id = def.object(forKey: "user_id") as? Int
        return user_id
    }
    
    class func getUserAvatar() -> String? {
        let def = UserDefaults.standard
        let avatar = def.object(forKey: "avatar") as? String
        return avatar
    }
    
    class func getUserbgGallery() -> String? {
        let def = UserDefaults.standard
        let bgGallery = def.object(forKey: "bgGallery") as? String
        return bgGallery
    }
    
    class func restartApp()  {
        guard let window = UIApplication.shared.keyWindow else { return }
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboard: UIStoryboard = UIStoryboard(name: "MainTab", bundle: nil)
        
        var vc: UIViewController
        if getApiToken() == nil {
            vc = mainStoryboard.instantiateInitialViewController()!
        }else{
            vc = storyboard.instantiateViewController(withIdentifier: "mainTab")
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
}
