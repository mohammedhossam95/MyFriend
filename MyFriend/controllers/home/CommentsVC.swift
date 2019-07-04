//
//  CommentsVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 2/4/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class CommentsVC: BaseViewController {
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var likesTable: UITableView!
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    var likesArr = [Comment]()
    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    var id: Int = 0
    var postUserID: Int = 0
    let Uid = helper.getUserId()
    
    var isLoading = false
    var current_page = 1
    var last_page = 1
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handlefollowersRefresh), for: .valueChanged)
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.showLoading()
        likesTable.addSubview(refresher)
        self.handlefollowersRefresh()
        
        let tabgetsure: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.likesTable.addGestureRecognizer(tabgetsure)
        commentTxt.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.sharedInstance.closeCommentConnction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getComment { (comment:Comment) in
            DispatchQueue.main.async {
            if comment.gallery_id == self.id{
                self.likesArr.append(comment)
                if self.likesArr.count > 0 && self.likesArr.count <= 1 {
                    if self.likesTable.isHidden {
                        self.likesTable.isHidden = false
                    }
                }
                self.likesTable.reloadData()
                self.scrollToBottom()
            }
            }
        }
        
        SocketIOManager.sharedInstance.getDeletedComment { (com: Comment) in
            if com.status == true {
                self.handlefollowersRefresh()
            } else {
                self.showAlertError(title: "Try Again Later")
            }
        }
    }
    
    /*
     //                if let index = self.likesArr.firstIndex(of: com){
     //                    self.likesArr.remove(at: index)
     //                    self.handlefollowersRefresh()
     //                }else{
     //                    self.showAlertError(title: "Try Again Later")
     //                    self.likesTable.reloadData()
     //                }
     
     */
    
    // MARK: Actions
    @objc func tableViewTapped() {
        self.commentTxt.endEditing(true)
    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        // _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func postComment(_ sender: UIButton) {
        if let comment = commentTxt.text, comment.isEmpty != true {
            if (commentTxt.text!.count) > 0 {
                SocketIOManager.sharedInstance.sendCommentToServerSocket(user_id: Uid!, comment: comment, gallery_id: self.id)
                commentTxt.endEditing(true)
                commentTxt.text = ""
                self.scrollToBottom()
                commentTxt.resignFirstResponder()
            }
        }
       
    }
    
    
    
    @objc func handlefollowersRefresh()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getMyComments(gallery_id: id) { (error: Error?, comments: [Comment]?, last_page: Int) in
            self.isLoading = false
            self.likesArr.removeAll()
            if let comments = comments {
                if comments.isEmpty {
                    self.likesTable.isHidden = true
                    self.likesArr.removeAll()
                    self.hideLoading()
                }else{
                    self.likesTable.isHidden = false
                    self.likesArr = comments
                    self.hideLoading()
                    self.likesTable.reloadData()
                    self.current_page = 1
                    self.last_page = last_page
                }
                
            }
        }
    }
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        ApiCalls.getMyComments(page: current_page+1, gallery_id: id) { (error: Error?, randomImages: [Comment]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages{
                self.likesArr.append(contentsOf: randomImages)
                self.likesTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                self.hideLoading()
            }
        }
    }
    func openProfileFromHome(Id:Int) {
        let userID = helper.getUserId()
        
        if userID == Id {
            let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
            VC.userId = Id
            userAboutVC.userId = Id
            userGallaryVC.id = Id
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func setupView() {
        
        if let userImage = helper.getUserAvatar(){
            imgView.kf.indicatorType = .activity
            if let url = URL(string: "\(URLs.photoMain)\(userImage)"){
                imgView.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }else{
            imgView.image = UIImage(named: "")
        }
        
        commentView.layer.cornerRadius = 10.0
        commentView.clipsToBounds = true
        commentView.layer.borderWidth = 1
        commentView.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        commentView.layer.masksToBounds = true
        
        postView.layer.cornerRadius = postView.bounds.height / 2
        postView.clipsToBounds = true
        postView.layer.borderWidth = 1
        postView.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        postView.layer.masksToBounds = true
        
        imgView.layer.cornerRadius = imgView.bounds.height / 2
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        imgView.layer.masksToBounds = true
    }
}


//M<ark:-  Load data in table view cell as messages
extension CommentsVC {
    func scrollToBottom(){
        // self.chatTableView.reloadData()
        // DispatchQueue.main.async {
        if likesArr.count > 0 {
            let indexPath = IndexPath(row: likesArr.count-1, section: 0)
            self.likesTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        //}
    }
}

extension CommentsVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.likesArr.count
        if indexPath.row == count-1 {
            self.LoadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.selectionStyle = .none
        likesTable.rowHeight = UITableView.automaticDimension
        likesTable.estimatedRowHeight = 150.0
        let user = likesArr[indexPath.row]
        cell.configreCell(user: user)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openProfileFromHome(Id: self.likesArr[indexPath.row].userId)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let commentDeleted = likesArr[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            //self.handleDelete(comment: commentDeleted, indexPath: indexPath)
            print(commentDeleted.userId)
            print(commentDeleted.id)
            print("post user id \(self.postUserID)")
            if let uid = self.Uid, uid == commentDeleted.userId {
                SocketIOManager.sharedInstance.deleteComment(user_id: self.Uid!, comment_id: commentDeleted.id)
            }else if let uid = self.Uid, uid == self.postUserID {
                SocketIOManager.sharedInstance.deleteComment(user_id: self.Uid!, comment_id: commentDeleted.id)
            }else {
                let alertController = UIAlertController(title: "", message: "You don't have permission to delete This comment", preferredStyle: .alert)
                let Confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(Confirm)
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }
            
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
   private func handleDelete(comment: Comment, indexPath: IndexPath) {
        self.likesTable.beginUpdates()
        self.likesTable.deleteRows(at: [indexPath], with: .automatic)
        self.likesTable.endUpdates()
    }
}


//Mark: TextField Delegate Methods
extension CommentsVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration:0.5){
            //self.textViewHeightConstraint.constant = 300
            self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration:0.5){
            // self.textViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
}
