//
//  AppDelegate.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/6/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        //SET INITIAL CONTROLLER
        let Storyboard: UIStoryboard = UIStoryboard(name: "MainTab", bundle: nil)
        if let token = helper.getApiToken() {
            print(token)
            let tab = Storyboard.instantiateViewController(withIdentifier: "mainTab")
            window?.rootViewController = tab
        }
//        GADMobileAds.configure(withApplicationID: URLs.YOUR_ADMOB_APP_ID)
        IQKeyboardManager.shared.enable = true
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: URLs.YOUR_ONESIGNAL_APP_ID,
                                        handleNotificationAction: { result in
                                            if let notification = result?.notification.payload {
                                                //"New Request" "New Message"
                                                guard let text = notification.title else {return}
                                                
                                            if text == "New Message"{
                                                    if let data = notification.additionalData{
                                                        
                                                        //                        print("data\(data)")
                                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                        let SB = storyBoard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                                                        SB.userNameTxt = data["senderName"] as! String
                                                        SB.profileImage = data["senderAvatar"] as! String
//                                                        SB.chat_id = data["threadId"] as! Int
//                                                        SB.id = data["senderId"] as! Int
                                                        
                                                        let tabsVC = storyBoard.instantiateViewController(withIdentifier: "tabsVC") as! TabsController
                                                        
//                                                        SB.callBackGetConversations = {
//                                                            if let x = tabsVC.tabBar.items?[3].badgeValue {
//                                                                var unreadInt = Int(x)
//                                                                unreadInt = unreadInt! - 1
//                                                                
//                                                                tabsVC.tabBar.items?[3].badgeValue = unreadInt! <= 0 ? nil : "\(unreadInt!)"
//                                                            }
//                                                        }
                                                        
                                                        self.window?.rootViewController?.present(SB, animated: true, completion: nil)
                                                    }
                                                }
                                            }
        }
            ,settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //SocketIOManager.sharedInstance.closeConnction()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

