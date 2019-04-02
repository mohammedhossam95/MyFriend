//
//  SocketIOManager.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/3/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    
    static var sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: URLs.mainSocket)!)
    
    func establishConnection() {
        socket.connect()
        print("Step1 connected")
    }
    
    func closeConnction() {
        socket.off("chat_listen")
    }
    func closeCommentConnction() {
        socket.off("comment_listen")
    }
    func sendOnlineStatus(user_id: Int){
        socket.emit("online", user_id)
    }
    
    
    //, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void
    
    func sendMessageToServerSocket(user_from: Int, user_to: Int,message: String, fileBase64: String,fileType: String){
        
        let data: [String: Any] = [
            "user_from" : user_from,
            "user_to" : user_to,
            "message" : message,
            "fileBase64" : fileBase64,
            "fileType" : fileType,
            "deviceType" : "mob"
        ]
       socket.emit("chat_emit", data)
    }
    
    func sendStroyToServerSocket(user_id: Int, fileBase64: String,text: String, bgcolor: String, fileType: String){
        
        let data: [String: Any] = [
            "user_id" : user_id,
            "text":text,
            "bgcolor": bgcolor,
            "fileBase64" : fileBase64,
            "fileType" : fileType,
            "deviceType" : "mob"
        ]
        socket.emit("story_emit", data)
        
    }

    func getStoriesFromSockets(completionHandler: @escaping (_ messageInfo: HomePost) -> Void) {
        socket.on("story_listen") { (data, socketAck) -> Void in
            let json = JSON(data)
            print(json)
            guard let data = json[0].dictionary else { return }
            let firstPost = HomePost()
            if let state = data["status"]?.bool, state == true{
                firstPost.status = "\(state)"
            }else{
                firstPost.status = "false"
            }
            
            completionHandler(firstPost)
        }
    }
    func sendEmojiToServerSocket(user_id: Int, gallery_id: Int,emojiType: String){
        let data: [String: Any] = [
            "user_id" : user_id,
            "gallery_id" : gallery_id,
            "emojiType" : emojiType,
            "deviceType" : "mob"
        ]
        socket.emit("emoji_emit", data)
    }
    
    func deletePostActionSocket(user_id: Int, gallery_id: Int){
        let data: [String: Any] = [
            "user_id" : user_id,
            "gallery_id" : gallery_id,
            "deviceType" : "mob"
        ]
        socket.emit("destroyHome_emit", data)
    }
    

    func getChatMessage(completionHandler: @escaping (_ messageInfo: CMessage) -> Void) {
        socket.on("chat_listen") { (data, SocketAckEmitter) in
            let json = JSON(data)

            guard let data = json[0].dictionary else { return }
            let firstPost = CMessage()
            firstPost.user_id = data["user_from"]?.int ?? 0
            firstPost.time = data["time"]?.string ?? ""
            firstPost.type = data["fileType"]?.string ?? ""
            firstPost.file = data["fileName"]?.string ?? ""
            firstPost.message = data["message"]?.string ?? ""

            completionHandler(firstPost)
        }
    }
    
    func getHomePostsSockets(completionHandler: @escaping (_ messageInfo: HomePost) -> Void) {
        socket.on("home_listen") { (data, SocketAckEmitter) in
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            let firstPost = HomePost()
            
            firstPost.name = data["name"]?.string ?? ""
            firstPost.id = data["gallery_id"]?.int ?? 0
            firstPost.time = data["time"]?.string ?? ""
            firstPost.date = data["date"]?.string ?? ""
            firstPost.type = data["fileType"]?.string ?? ""
            firstPost.avatar = data["avatar"]?.string ?? ""
            firstPost.galleryFile = data["fileName"]?.string ?? ""
            firstPost.status = data["status"]?.string ?? ""
            firstPost.userId = data["user_id"]?.int ?? 0
            firstPost.liked = data["liked"]?.int ?? 0
            firstPost.love = data["love"]?.int ?? 0
            firstPost.wow = data["wow"]?.int ?? 0
            
            firstPost.hasLiked = data["hasLiked"]?.string ?? ""
            firstPost.hasLoved = data["hasLoved"]?.string ?? ""
            firstPost.hasWowed = data["hasWowed"]?.string ?? ""
            
            firstPost.status = data["status"]?.string ?? ""
            firstPost.exception = data["exception"]?.string ?? ""
            
            completionHandler(firstPost)
        }
    }
    func deleteHomePost(completionHandler: @escaping (_ messageInfo: HomePost) -> Void) {
        socket.on("home_listen") { (data, socketAck) -> Void in
            
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            let firstPost = HomePost()
            
            firstPost.name = data["name"]?.string ?? ""
            firstPost.id = data["gallery_id"]?.int ?? 0
            firstPost.time = data["time"]?.string ?? ""
            firstPost.date = data["date"]?.string ?? ""
            firstPost.type = data["fileType"]?.string ?? ""
            firstPost.avatar = data["avatar"]?.string ?? ""
            firstPost.galleryFile = data["fileName"]?.string ?? ""
            firstPost.userId = data["user_id"]?.int ?? 0
            firstPost.liked = data["liked"]?.int ?? 0
            firstPost.love = data["love"]?.int ?? 0
            firstPost.wow = data["wow"]?.int ?? 0
            
            completionHandler(firstPost)
        }
    }
    
    func getEmojiPostsSockets(completionHandler: @escaping (_ messageInfo: HomePost) -> Void) {
        socket.on("emoji_listen") { (data, socketAck) -> Void in
            
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            let firstPost = HomePost()
            
         
            firstPost.id = data["gallery_id"]?.int ?? 0
         
            firstPost.type = data["fileType"]?.string ?? ""
            firstPost.avatar = data["avatar"]?.string ?? ""
           // let meEmoji = data["meEmoji"]?.string ?? ""
            guard let meEmoji = data["meEmoji"]!.string else { return }
            firstPost.userId = data["user_id"]?.int ?? 0
            firstPost.liked = data["liked"]?.int ?? 0
            firstPost.love = data["love"]?.int ?? 0
            firstPost.wow = data["wow"]?.int ?? 0
            
            if meEmoji == "liked" {
                firstPost.hasLiked = "true"
            }else if meEmoji == "love" {
                firstPost.hasLoved = "true"
            }else if meEmoji == "wow" {
                firstPost.hasWowed = "true"
            }else {
                firstPost.hasLiked = "false"
                firstPost.hasLoved = "false"
                firstPost.hasWowed = "false"
            }
            
            completionHandler(firstPost)
        }
    }
    //send Video gallery to server by socket
    func sendVideoToServerSocket(user_id: Int, text: String, fileBase64: String, fileType: String ){
        let data: [String: Any] = [
            "user_id" : user_id,
            "text":text,
            "fileBase64" : fileBase64,
            "fileType" : fileType,
            "deviceType" : "mob"
        ]
        
        socket.emit("home_emit", data)
        
    }
    func getgalleryPostsSockets(completionHandler: @escaping (_ messageInfo: GPhoto) -> Void) {
        socket.on("home_listen") { (data, socketAck) -> Void in
            
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            
            let firstPost = GPhoto()
            firstPost.id = data["gallery_id"]?.int ?? 0
            firstPost.file = data["fileName"]?.string ?? ""
            firstPost.type = data["fileType"]?.string ?? ""
            firstPost.liked = data["liked"]?.int ?? 0
            firstPost.love = data["love"]?.int ?? 0
            firstPost.wow = data["wow"]?.int ?? 0
            firstPost.status = data["status"]?.string ?? ""
            firstPost.exception = data["exception"]?.string ?? ""
            
            completionHandler(firstPost)
        }
    }
    //All Comment Sockets
    
    func sendCommentToServerSocket(user_id: Int, comment: String, gallery_id: Int){
        let data: [String: Any] = [
            "gallery_id" : gallery_id,
            "user_id" : user_id,
            "comment" : comment,
            "fileBase64":"",
            "fileType" : "text",
            "deviceType" : "mob"
        ]
        socket.emit("comment_emit", data)
    }
    
    func getComment(completionHandler: @escaping (_ messageInfo: Comment) -> Void) {
        socket.on("comment_listen") { (data, SocketAckEmitter) in
            
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            let firstPost = Comment()
            firstPost.userId = data["user_id"]?.int ?? 0
            firstPost.name = data["username"]?.string ?? ""
            firstPost.time = data["time"]?.string ?? ""
            firstPost.date = data["date"]?.string ?? ""
            firstPost.fileType = data["fileType"]?.string ?? ""
            firstPost.fileName = data["fileName"]?.string ?? ""
            firstPost.comment = data["comment"]?.string ?? ""
            firstPost.avatar = data["avatar"]?.string ?? ""
            firstPost.gallery_id = data["gallery_id"]?.int ?? 0
            firstPost.id = data["comment_id"]?.int ?? 0
            completionHandler(firstPost)
        }
    }

    //delete Comment
    func deleteComment(user_id: Int, comment_id: Int){
        let data: [String: Any] = [
            "user_id" : user_id,
            "comment_id" : comment_id,
            "deviceType" : "mob"
        ]
        socket.emit("destroyComment_emit", data)
    }

    func getDeletedComment(completionHandler: @escaping (_ messageInfo: Comment) -> Void) {
        socket.on("destroyComment_listen") { (data, SocketAckEmitter) in
            let json = JSON(data)
            guard let data = json[0].dictionary else { return }
            let firstPost = Comment()
            
            firstPost.userId = data["user_id"]?.int ?? 0
            firstPost.id = data["comment_id"]?.int ?? 0
            firstPost.gallery_id = data["gallery_id"]?.int ?? 0
            firstPost.status = data["status"]?.bool ?? false
            firstPost.exception =  data["exception"]?.string ?? ""
            completionHandler(firstPost)
        }
    }
    func getNotificationBadge(completionHandler: @escaping (_ userId: Int, _ status: String, _ exception: String) -> Void) {
        socket.on("notifications_listen") { (data, SocketAckEmitter) in
            
            let json = JSON(data)
//            guard let data = json[0].dictionary else { return }

            print(json)
//            let userId = data["user_id"]?.int ?? 0
//            let status = data["status"]?.string ?? ""
//            let exception = data["exception"]?.string ?? ""

            let userId = 2
            let status = "true"
            let exception = "true"
            
            completionHandler(userId, status, exception)
        }
    }
    func getNewMessage(completionHandler: @escaping (_ userId: Int, _ status: String, _ exception: String) -> Void) {
        socket.on("notificationsMsg_listen") { (data, SocketAckEmitter) in
            
            let json = JSON(data)
            print(json)
            
            let userId = 2
            let status = "true"
            let exception = "true"
            
            completionHandler(userId, status, exception)
        }
    }
}
