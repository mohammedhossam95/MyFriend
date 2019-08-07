//
//  ChatRoomVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/2/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import OneSignal
import IQKeyboardManagerSwift
import YPImagePicker

class ChatRoomVC: BaseViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTV: UITextField!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var userNameTxt: String = ""
    var profileImage: String = ""
    var frindID: Int = -1
    var imagePiker: UIImagePickerController!
    let Uid = helper.getUserId()
    static var data = [CMessage]()
    
    var callbackClosure: (() -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callbackClosure?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.showSpecificLoading()
        loadData(friend_id: frindID)
        scrollToBottom()
    }
    
    func setupView() {
        let tabgetsure: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.chatTableView.addGestureRecognizer(tabgetsure)
        
        chatTableView.tableFooterView = UIView()
        chatTableView.separatorInset = .zero
        chatTableView.contentInset = .zero
        messageTV.delegate = self
        IQKeyboardManager.shared.enable = false
        
        userName.text = userNameTxt
        
        if let url = URL(string: URLs.photoMain + profileImage)
        {
            self.hideSpecificLoading()
            userImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultUser") , options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        userImage.layer.masksToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.sharedInstance.closeConnction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo: CMessage) -> Void in
        //    DispatchQueue.main.async { [weak self] in
                ChatRoomVC.data.append(messageInfo)
                self.chatTableView.reloadData()
                self.scrollToBottom()
     //       }
        }
    }

    
    // MARK: Actions
    @objc func tableViewTapped() {
        self.messageTV.endEditing(true)
    }

    @IBAction func chatBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if (messageTV.text!.count) > 0 {
            messageTV.endEditing(true)
            SocketIOManager.sharedInstance.sendMessageToServerSocket(user_from: Uid!, user_to: frindID, message: messageTV.text!, fileBase64: "", fileType: "text")
            messageTV.text = ""
            self.scrollToBottom()
            messageTV.resignFirstResponder()
        }
    }
    @IBAction func sendPhoto(_ sender: UIButton) {
        changePic()
    }
    
    @objc func changePic() {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        config.isScrollToChangeModesEnabled = false
        config.library.maxNumberOfItems = 1
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            if let photo = items.singlePhoto {
                let uid = helper.getUserId()
                let imageData = photo.image.jpegData(compressionQuality: 0.5)
                let base64String =  imageData?.base64EncodedString(options: [])
                guard let base64 = base64String else { return }
                let base64String1 = "data:image/jpeg;base64,\(base64)"
                SocketIOManager.sharedInstance.sendMessageToServerSocket(user_from: uid!, user_to: self.frindID, message: "", fileBase64: base64String1, fileType: "image")
            }
            picker.dismiss(animated: true, completion: nil)
        }
        self.present(picker, animated: true, completion: nil)
    }
    
}


//M<ark:-  Load data in table view cell as messages
extension ChatRoomVC {
    func scrollToBottom(){
            if ChatRoomVC.data.count > 0 {
                let indexPath = IndexPath(row: ChatRoomVC.data.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
    }
    
    func loadData(friend_id: Int) {
        ApiCalls.LoadUserChat(frindID: friend_id) { (error: Error?, messages: [CMessage]?, last_page: Int) in
            ChatRoomVC.data.removeAll() 
                if let message = messages{
                    self.hideSpecificLoading()
                    for arrayIndex in 0..<message.count {
                         ChatRoomVC.data.append(message[(message.count - 1) - arrayIndex])
                    }
                   // ChatRoomVC.data = message
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                }
            else {
                self.hideSpecificLoading()
                self.showAlertError(title: ("الرجاء التحقق من الاتصال بالشبكة") )
            }
        }
    }
}

//Mark table view datasource delegate
extension ChatRoomVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRoomVC.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = helper.getUserId()
        let messageType = ChatRoomVC.data[indexPath.row].type
        
        if messageType == "image"{
            chatTableView.rowHeight = 190.0
            if ChatRoomVC.data[indexPath.row].user_id == id{
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "photorecieverCell", for: indexPath) as! photorecieverCell
                 cell.selectionStyle = .none
                cell.photoImage.kf.indicatorType = .activity
                if let url = URL(string: "\(URLs.photoMain)\(ChatRoomVC.data[indexPath.row].file)") {
                    cell.photoImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
                return cell
            }else {
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "photoMessageCell", for: indexPath) as! photoMessageCell
                 cell.selectionStyle = .none
                cell.photoImage.kf.indicatorType = .activity
                if let url = URL(string: "\(URLs.photoMain)\(ChatRoomVC.data[indexPath.row].file)")
                {
                    cell.photoImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
                return cell
            }
           
            
        }else if messageType == "video"{
        }else{
                    chatTableView.rowHeight = UITableView.automaticDimension
                    chatTableView.estimatedRowHeight = 100.0
            if ChatRoomVC.data[indexPath.row].user_id == id{
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "chatRecieverCell", for: indexPath) as! chatRecieverCell
                 cell.selectionStyle = .none
                
                cell.senderMessageLbl.text = ChatRoomVC.data[indexPath.row].message
                cell.messageTime.text = ChatRoomVC.data[indexPath.row].time
                return cell
                
            }else{
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "chatSenderCell", for: indexPath) as! chatSenderCell
                cell.selectionStyle = .none
                cell.senderMessageLbl.text = ChatRoomVC.data[indexPath.row].message
                cell.messageTime.text = ChatRoomVC.data[indexPath.row].time
                return cell
            }
        }
        return UITableViewCell()
    }
}

//Mark: TextField Delegate Methods
extension ChatRoomVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration:0.5){
            let height = UIScreen.main.bounds.height >= 812 ? 320 : 275
            self.textViewHeightConstraint.constant = CGFloat(height) + 40.0
            self.view.layoutIfNeeded()
        }
        scrollToBottom()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration:0.5){
            self.textViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
}
