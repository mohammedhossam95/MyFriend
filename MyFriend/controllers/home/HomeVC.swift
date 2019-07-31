//
//  HomeVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import GoogleMobileAds
import iOSPhotoEditor

class HomeVC: BaseViewController{
    // @IBOutlet weak var usersStoriesCollection: UICollectionView!
    @IBOutlet weak var userPostsTable: UITableView!
    @IBOutlet weak var goView: UIView!
    
    
    var collectionModel: RootClass! = RootClass(JSON: [:])
    var imagePiker: UIImagePickerController!
    
    var collectionStories = [data]()
    var tablePosts = [HomePost]()
    var isLoading = false
    var current_page = 1
    var last_page = 1
    var index1:IndexPath?
    
    let avpController = AVPlayerViewController()
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = URLs.bannarId
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        return refresher
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        //Ads
        userPostsTable.register(UINib(nibName: "BannerAd", bundle: nil),
                           forCellReuseIdentifier: "BannerViewCell")
        // Do any additional setup after loading the view.
        goView.layer.cornerRadius = 10.0
        goView.clipsToBounds = true
        userPostsTable.addSubview(refresher)
        showLoading()
        adBannerView.load(GADRequest())
        handleRefresher()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        if index1 != nil {
            let cell = userPostsTable.cellForRow(at: index1!) as! videoCell
            cell.PostVideo.isLoop = true
            if cell.PostVideo.checkCurrent(){
                cell.PostVideo.pause()
                cell.soundImage.image = UIImage(named: "soundOff")
            }
        }
        
    }

   //Mark:- Socket
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getNewMessage { (userId: Int, status: String, exception: String) in
            DispatchQueue.main.async {
                if status != "false"{
                    print("ios true")
                }
            }
        }
        SocketIOManager.sharedInstance.getHomePostsSockets { (post: HomePost) in
            print("post socket ",post)
            DispatchQueue.main.async {
                if post.status != "false"{
                    
                    self.tablePosts.append(post)
                    self.handlePosts()
                }else {
                    
                    let alertController = UIAlertController(title: "Something Error", message:  post.exception, preferredStyle: .alert)
                    let Confirm = UIAlertAction(title: "Try Again", style: .cancel)
                    alertController.addAction(Confirm)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                    
                }

            }
        }
        SocketIOManager.sharedInstance.getStoriesFromSockets { (first: HomePost) in
            DispatchQueue.main.async {
                if first.status != "false"{
                    self.handleStories()
                    self.userPostsTable.reloadData()
                }else{
                    print("Status false story")
                }
            }
        }
    }
    
    @IBAction func addStoryBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Story Type", message: "", preferredStyle: .actionSheet)
        
        let opentextStoryBtn = UIAlertAction(title: "Text", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "StoryTextVC") as! StoryTextVC
            self.navigationController?.present(VC, animated: true, completion: nil)
        }
        
        let openCameraBtn = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }
        let openGalleryBtn = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.opengallery()
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel btn")
        }
        alertController.addAction(openCameraBtn)
        alertController.addAction(openGalleryBtn)
        alertController.addAction(opentextStoryBtn)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
    
    var videoUrl: URL?{
        didSet{
            self.showLoading()
            guard let video = videoUrl else { return }
            let uid = helper.getUserId()
            
             DispatchQueue.main.async {
                print("This is run on the background queue")
                do {
                    self.showLoading()
                    let videoData: Data = try Data(contentsOf: video)
                    let videoBase64String = videoData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                    let base64String1 = "data:video/mp4;base64,\(videoBase64String)"
                   
                        print("This is run on the main queue, after the previous code in outer block")
                        print(base64String1)
                        SocketIOManager.sharedInstance.sendStroyToServerSocket(user_id: uid!, fileBase64: base64String1, text: "", bgcolor: "", fileType: "video")
                } catch let error{
                    print("video uploading error")
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    var picker_image: UIImage?{
        didSet{
            self.showLoading()
            guard let image = picker_image else { return }
            let uid = helper.getUserId()
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            let x = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            //let base64String =  imageData?.base64EncodedString(options: [])
            //guard let base64 = base64String else { return }
            guard let base64 = x else { return }
            let base64String1 = "data:image/jpeg;base64,\(base64)"
            // print("the first photo is \(base64String1) the end")
            SocketIOManager.sharedInstance.sendStroyToServerSocket(user_id: uid!, fileBase64: base64String1, text: "", bgcolor: "", fileType: "image")
        }
    }
    func openCamera() {
        imagePiker = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePiker.sourceType = UIImagePickerController.SourceType.camera
            imagePiker.delegate = self
            imagePiker.cameraFlashMode = .auto
            imagePiker.cameraDevice = .rear
            imagePiker.showsCameraControls = true
            imagePiker.videoMaximumDuration = 40.0
            imagePiker.videoQuality = .typeMedium
            imagePiker.setEditing(true, animated: true)
            imagePiker.mediaTypes = ["public.image", "public.movie"]
            present(imagePiker, animated: true, completion: nil)
        }else {
            opengallery()
        }
    }
    
    func opengallery() {
        imagePiker = UIImagePickerController()
        imagePiker.videoMaximumDuration = 40.0
        imagePiker.sourceType = .photoLibrary
        imagePiker.mediaTypes = ["public.image", "public.movie"]
        imagePiker.delegate = self
        self.present(imagePiker, animated: true, completion: nil)
    }
    
    func reportPost(post: HomePost, reason: String, indexpath: IndexPath) {

        self.showLoading()
        ApiCalls.ReportGallery(post: post, reason: reason) { (error: Error?, success : Bool, status: String) in
            if success {
                self.hideLoading()
                let alertController = UIAlertController(title: "Report", message: "This post was Reported successfully", preferredStyle: .alert)
                let cancelBtn = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(cancelBtn)
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }else {
                if status == "gallery_id reported exists" {
                    let alertController = UIAlertController(title: "Report", message: "This post was Reported Before", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
                    alertController.addAction(cancelBtn)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                    self.hideLoading()
                }else{
                    
                    self.hideLoading()
                    self.showAlertError(title: "status \(status)")
                }
            }
        }
    }
    
    func openAlert(post: HomePost, indexpath: IndexPath) {
        let alertController = UIAlertController(title: "", message: "post options", preferredStyle: .actionSheet)
        
        let openCameraBtn = UIAlertAction(title: "Report", style: .destructive) { (action) in
            let alertController = UIAlertController(title: "Reason", message: "Add reason for reporting This post", preferredStyle: .alert)
            
            alertController.addTextField { (reportTxt: UITextField) in
                reportTxt.placeholder = "Reason"
                reportTxt.textAlignment = .center
                
            }
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(UIAlertAction(title: "send", style: .destructive) { (action: UIAlertAction) in
                guard let reason = alertController.textFields?.first?.text?.trimmed, !reason.isEmpty else {return}
                self.reportPost(post: post, reason: reason, indexpath: indexpath)
            })
            alertController.addAction(cancelBtn)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(openCameraBtn)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func deletePost(user_id: Int, id: Int) {
        print("Post reported succesfully")
    }
    
    //Mark :- openProfileFromHome
    
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
    
    func handleMenubtn(Id:Int, gallery_id: Int) {
        let userID = helper.getUserId()
        
        if userID == Id {
            let alertController = UIAlertController(title: "Post Settings", message: "Please select Your option", preferredStyle: .actionSheet)
            let DeleteBtn = UIAlertAction(title: "Delete Post", style: .destructive) { (action) in
                //  self.deletePost(post: Id, indexpath: gallery_id)
            }
            
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(DeleteBtn)
            alertController.addAction(cancelBtn)
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let SB = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(SB, animated: true)
    }
    
    @objc func handleRefresher()  {
        handlePosts()
        handleStories()
    }
    
    @objc func handlePosts()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getPosts { (error: Error?, posts: [HomePost]?, last_page: Int) in
            self.isLoading = false
            if let posts = posts{
                
                self.tablePosts = posts
                self.userPostsTable.reloadData()
                self.current_page = 1
                self.last_page = last_page
                
                //online status
                guard let user_id1 = helper.getUserId() else { return }
                print("home Api \(user_id1)")
                SocketIOManager.sharedInstance.sendOnlineStatus(user_id: user_id1)
                self.hideLoading()
            }
        }
        
    }
    
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        ApiCalls.getPosts(page: current_page+1) { (error: Error?, posts: [HomePost]?, last_page: Int) in
            self.isLoading = false
            if let posts = posts{
                //self.tablePosts = posts
                self.tablePosts.append(contentsOf: posts)
                self.userPostsTable.reloadData()
                self.current_page += 1
                self.last_page = last_page
                self.isLoading = false
            }
        }
    }
    
    //Mark:- Stories Data
    
    @objc func handleStories() {
        self.collectionStories.removeAll()
        ApiCalls.getStories {(error: Error?, model: RootClass?, last_page: Int) in
            if let mmodel = model {
                self.hideLoading()
                self.collectionStories.removeAll()
                self.collectionModel = mmodel
                for data in (self.collectionModel.properties?.data)! {
                    self.collectionStories.append(data)
                }
                self.userPostsTable.reloadData()
            }
        }
    }
}

//Mark Table View Delegate Methods
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablePosts.count
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoCell
        // Check the player object is set (unwrap it)
        if let player = cell.PostVideo.player {
            // Check if the player is playing
            if player.rate != 0 {
                // Pause the player
                player.pause()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.tablePosts.count
        
        if indexPath.row == count - 1 {
            self.LoadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120.0
        }
        return 420.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storiesTableViewCell", for: indexPath) as! storiesTableViewCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
            if let userImage = helper.getUserAvatar(){
                
                cell.addstorybackground.kf.indicatorType = .activity
                if let url = URL(string: "\(URLs.photoMain)\(userImage)"){
                    cell.addstorybackground.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
            }else{
                cell.addstorybackground.image = UIImage(named: "")
            }
            
            return cell
        }else{
            let NotificationType = tablePosts[indexPath.row-1].type
            if NotificationType == "image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableViewCell", for: indexPath) as! postsTableViewCell
                cell.userPhoto.kf.indicatorType = .activity
                if let url = URL(string: URLs.photoMain + tablePosts[indexPath.row-1].avatar){
                    cell.userPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
                
                
                if let userID = helper.getUserId(), userID == self.tablePosts[indexPath.row-1].userId {
                    cell.btnmenubtn.isHidden = true
                }else {
                    cell.btnmenubtn.isHidden = false
                }
                
                if self.tablePosts[indexPath.row-1].verified == 0 {
                    cell.VerificationImg.isHidden = true
                }else {
                    cell.VerificationImg.isHidden = false
                }
                cell.menuBtn = {
                    self.openAlert(post: self.tablePosts[indexPath.row-1], indexpath: indexPath)
                }
                cell.profileBtn = {
                    self.openProfileFromHome(Id: self.tablePosts[indexPath.row-1].userId)
                }
                cell.playBtn = {
                    if self.tablePosts[indexPath.row-1].hasStroy == "true" {
                        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "ViewMemoriesVC") as! ViewMemoriesVC
                        VC.post = self.tablePosts[indexPath.row-1]
                        self.navigationController?.present(VC, animated: true, completion: nil)
                    } else {
                        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
                        VC.gallery_id = self.tablePosts[indexPath.row-1].id
                        self.navigationController?.present(VC, animated: true, completion: nil)
                    }
                }
                
                SocketIOManager.sharedInstance.getEmojiPostsSockets(completionHandler: { (homePost: HomePost) in
                    DispatchQueue.main.async {
                        cell.postNumOfLikes.text = String(homePost.liked)
                        cell.postNumOfKiss.text = String(homePost.love)
                        cell.postNumOfWows.text = String(homePost.wow)
                        let totoal  = homePost.liked + homePost.love + homePost.wow
                        cell.postNumOfEmojis.text = String(totoal)
                    }
                })
                
                cell.likePost = {
                    let userID = helper.getUserId()
                    if cell.postNumOfLikes.textColor == UIColor.red {
                        cell.imoLove.image = UIImage(named: "imoLove")
                        cell.postNumOfLikes.textColor = UIColor.black
                    }else{
                        cell.imoLove.image = UIImage(named: "loveC")
                        cell.postNumOfLikes.textColor = UIColor.red
                    }
                    cell.postNumOfKiss.textColor = UIColor.black
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    cell.postNumOfWows.textColor = UIColor.black
                    cell.imoWow.image = UIImage(named: "imoWow")
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "liked")
                }
                
                cell.kissPost = {
                    let userID = helper.getUserId()
                    if cell.postNumOfKiss.textColor == UIColor.red {
                        cell.imoKiss.image = UIImage(named: "imoKiss")
                        cell.postNumOfKiss.textColor = UIColor.black
                    }else{
                        cell.imoKiss.image = UIImage(named: "kissC")
                        cell.postNumOfKiss.textColor = UIColor.red
                    }
                    cell.postNumOfLikes.textColor = UIColor.black
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfWows.textColor = UIColor.black
                    cell.imoWow.image = UIImage(named: "imoWow")
                    
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "love")
                }
                
                cell.wowPost = {
                    let userID = helper.getUserId()
                    
                    if cell.postNumOfWows.textColor == UIColor.red {
                        cell.postNumOfWows.textColor = UIColor.black
                        cell.imoWow.image = UIImage(named: "imoWow")
                    }else{
                        cell.imoWow.image = UIImage(named: "wowC")
                        cell.postNumOfWows.textColor = UIColor.red
                    }
                    cell.postNumOfLikes.textColor = UIColor.black
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfKiss.textColor = UIColor.black
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "wow")
                }
                cell.viewsPost = {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "ViewsVC") as! ViewsVC
                    VC.id = self.tablePosts[indexPath.row-1].id
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                cell.commentPost = {
                    let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                    let SB = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
                    SB.id = self.tablePosts[indexPath.row-1].id
                    SB.postUserID = self.tablePosts[indexPath.row-1].userId
                    self.navigationController?.present(SB, animated: true, completion: nil)
                }
                cell.viewEmoj = {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "EmojiVC") as! EmojiVC
                    LikesVC.id = self.tablePosts[indexPath.row-1].id
                    KissVC.id = self.tablePosts[indexPath.row-1].id
                    WowsVC.id = self.tablePosts[indexPath.row-1].id
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                
                if tablePosts[indexPath.row-1].hasLiked == "false" {
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfLikes.textColor = UIColor.black
                }else{
                    cell.imoLove.image = UIImage(named: "loveC")
                    cell.postNumOfLikes.textColor = UIColor.red
                }
                
                if tablePosts[indexPath.row-1].hasLoved == "false" {
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    cell.postNumOfKiss.textColor = UIColor.black
                }else{
                    cell.imoKiss.image = UIImage(named: "kissC")
                    cell.postNumOfKiss.textColor = UIColor.red
                }
                
                if tablePosts[indexPath.row-1].hasWowed == "false" {
                    cell.imoWow.image = UIImage(named: "imoWow")
                    cell.postNumOfWows.textColor = UIColor.black
                }else{
                    cell.imoWow.image = UIImage(named: "wowC")
                    cell.postNumOfWows.textColor = UIColor.red
                }
                cell.postUserName.text = tablePosts[indexPath.row-1].name
                cell.postTime.text = tablePosts[indexPath.row-1].time
                cell.postNumOfLikes.text = String(tablePosts[indexPath.row-1].liked)
                cell.postNumOfKiss.text = String(tablePosts[indexPath.row-1].love)
                cell.postNumOfWows.text = String(tablePosts[indexPath.row-1].wow)
                cell.postNumOfComments.text = "\(tablePosts[indexPath.row-1].comments) Comments"
                cell.postNumOfEmojis.text = String(tablePosts[indexPath.row-1].liked + tablePosts[indexPath.row-1].wow + tablePosts[indexPath.row-1].love)
                cell.postNumOfViews.text = "\(tablePosts[indexPath.row-1].views) View"
                
                if tablePosts[indexPath.row-1].hasStroy == "true" {
                    cell.postPhoto.isHidden = false
                    cell.StoryTextLbl.isHidden = false
//                    cell.StoryTextLbl.text = "#yourStory&Photo Read More ..."
                    cell.StoryTextLbl.text = tablePosts[indexPath.row-1].text
                    cell.postPhoto.kf.indicatorType = .activity
                    if let url = URL(string: "\(URLs.photoMain)\(tablePosts[indexPath.row-1].galleryFile)"){
                        cell.postPhoto.contentMode = .scaleAspectFill
                        cell.postPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil) }
                }else{
                    cell.postPhoto.isHidden = false
                    cell.StoryTextLbl.isHidden = true
                    cell.postPhoto.kf.indicatorType = .activity
                    if let url = URL(string: "\(URLs.photoMain)\(tablePosts[indexPath.row-1].galleryFile)"){
                        cell.postPhoto.contentMode = .scaleAspectFill
                        cell.postPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil) }
                }
                
                return cell
            }else {
                
                //MarK: - Video Cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoCell
                
                cell.userPhoto.kf.indicatorType = .activity
                if let url = URL(string: URLs.photoMain + tablePosts[indexPath.row-1].avatar){
                    cell.userPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
                if let userID = helper.getUserId(), userID == self.tablePosts[indexPath.row-1].userId {
                    cell.btnmenubtn.isHidden = true
                }else {
                    cell.btnmenubtn.isHidden = false
                }
                if self.tablePosts[indexPath.row-1].verified == 0 {
                    cell.VerificationImg.isHidden = true
                }else {
                    cell.VerificationImg.isHidden = false
                }
                cell.menuBtn = {
                    self.openAlert(post: self.tablePosts[indexPath.row-1], indexpath: indexPath)
                }
                cell.profileBtn = {
                    cell.PostVideo.isLoop = true
                    if cell.PostVideo.checkCurrent(){
                        cell.PostVideo.pause()
                        cell.soundImage.image = UIImage(named: "soundOff")
                    }
                    self.openProfileFromHome(Id: self.tablePosts[indexPath.row-1].userId)
                }
                cell.playBtn = {
                    ApiCalls.getSinglePhoto(gallery_id: self.tablePosts[indexPath.row-1].id) { (error: Error?, singleGallery: SingleGallery?) in
                        if let singleGallery = singleGallery{
                            print(singleGallery.galleryId)
                            cell.PostVideo.isLoop = true
                            if cell.PostVideo.checkCurrent(){
                                if let url = URL(string: "\(URLs.photoMain)\(self.tablePosts[indexPath.row-1].galleryFile)"){
                                    let video = AVPlayer(url: url)
                                    let videoPlayer = AVPlayerViewController()
                                    videoPlayer.player = video
                                    self.present(videoPlayer, animated: true, completion: {
                                        video.play()
                                    })
                                }
                                cell.PostVideo.pause()
                                cell.soundImage.image = UIImage(named: "soundOff")
                            }else{
                                
                                if let url = URL(string: "\(URLs.photoMain)\(self.tablePosts[indexPath.row-1].galleryFile)"){
                                    let video = AVPlayer(url: url)
                                    let videoPlayer = AVPlayerViewController()
                                    videoPlayer.player = video
                                    self.present(videoPlayer, animated: true, completion: {
                                        video.play()
                                    })
                                }
                                cell.soundImage.image = UIImage(named: "soundOff")
                            }
                        }
                    }
                }
                
                SocketIOManager.sharedInstance.getEmojiPostsSockets(completionHandler: { (homePost: HomePost) in
                    DispatchQueue.main.async {
                        cell.postNumOfLikes.text = String(homePost.liked)
                        cell.postNumOfKiss.text = String(homePost.love)
                        cell.postNumOfWows.text = String(homePost.wow)
                        let totoal  = homePost.liked + homePost.love + homePost.wow
                        cell.postNumOfEmojis.text = String(totoal)
                    }
                })
                
                cell.likePost = {
                    let userID = helper.getUserId()
                    if cell.postNumOfLikes.textColor == UIColor.red {
                        cell.imoLove.image = UIImage(named: "imoLove")
                        cell.postNumOfLikes.textColor = UIColor.black
                    }else{
                        cell.imoLove.image = UIImage(named: "loveC")
                        cell.postNumOfLikes.textColor = UIColor.red
                    }
                    cell.postNumOfKiss.textColor = UIColor.black
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    cell.postNumOfWows.textColor = UIColor.black
                    cell.imoWow.image = UIImage(named: "imoWow")
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "liked")
                }
                
                cell.kissPost = {
                    let userID = helper.getUserId()
                    if cell.postNumOfKiss.textColor == UIColor.red {
                        cell.imoKiss.image = UIImage(named: "imoKiss")
                        cell.postNumOfKiss.textColor = UIColor.black
                    }else{
                        cell.imoKiss.image = UIImage(named: "kissC")
                        cell.postNumOfKiss.textColor = UIColor.red
                    }
                    cell.postNumOfLikes.textColor = UIColor.black
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfWows.textColor = UIColor.black
                    cell.imoWow.image = UIImage(named: "imoWow")
                    
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "love")
                }
                
                cell.wowPost = {
                    let userID = helper.getUserId()
                    
                    if cell.postNumOfWows.textColor == UIColor.red {
                        cell.postNumOfWows.textColor = UIColor.black
                        cell.imoWow.image = UIImage(named: "imoWow")
                    }else{
                        cell.imoWow.image = UIImage(named: "wowC")
                        cell.postNumOfWows.textColor = UIColor.red
                    }
                    cell.postNumOfLikes.textColor = UIColor.black
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfKiss.textColor = UIColor.black
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    
                    SocketIOManager.sharedInstance.sendEmojiToServerSocket(user_id: userID!, gallery_id: self.tablePosts[indexPath.row-1].id, emojiType: "wow")
                }
                cell.viewsPost = {
                    cell.PostVideo.isLoop = true
                    if cell.PostVideo.checkCurrent(){
                        cell.PostVideo.pause()
                        cell.soundImage.image = UIImage(named: "soundOff")
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "ViewsVC") as! ViewsVC
                    VC.id = self.tablePosts[indexPath.row-1].id
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                cell.commentPost = {
                    cell.PostVideo.isLoop = true
                    if cell.PostVideo.checkCurrent(){
                        cell.PostVideo.pause()
                        cell.soundImage.image = UIImage(named: "soundOff")
                    }
                    let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                    let SB = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
                    SB.id = self.tablePosts[indexPath.row-1].id
                    SB.postUserID = self.tablePosts[indexPath.row-1].userId
                    self.navigationController?.present(SB, animated: true, completion: nil)
                }
                cell.viewEmoj = {
                    cell.PostVideo.isLoop = true
                    if cell.PostVideo.checkCurrent(){
                        cell.PostVideo.pause()
                        cell.soundImage.image = UIImage(named: "soundOff")
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "EmojiVC") as! EmojiVC
                    LikesVC.id = self.tablePosts[indexPath.row-1].id
                    KissVC.id = self.tablePosts[indexPath.row-1].id
                    WowsVC.id = self.tablePosts[indexPath.row-1].id
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                
                if tablePosts[indexPath.row-1].hasLiked == "false" {
                    cell.imoLove.image = UIImage(named: "imoLove")
                    cell.postNumOfLikes.textColor = UIColor.black
                }else{
                    cell.imoLove.image = UIImage(named: "loveC")
                    cell.postNumOfLikes.textColor = UIColor.red
                }
                
                if tablePosts[indexPath.row-1].hasLoved == "false" {
                    cell.imoKiss.image = UIImage(named: "imoKiss")
                    cell.postNumOfKiss.textColor = UIColor.black
                }else{
                    cell.imoKiss.image = UIImage(named: "kissC")
                    cell.postNumOfKiss.textColor = UIColor.red
                }
                
                if tablePosts[indexPath.row-1].hasWowed == "false" {
                    cell.imoWow.image = UIImage(named: "imoWow")
                    cell.postNumOfWows.textColor = UIColor.black
                }else{
                    cell.imoWow.image = UIImage(named: "wowC")
                    cell.postNumOfWows.textColor = UIColor.red
                }
                cell.postUserName.text = tablePosts[indexPath.row-1].name
                cell.postTime.text = tablePosts[indexPath.row-1].time
                cell.postNumOfLikes.text = String(tablePosts[indexPath.row-1].liked)
                cell.postNumOfKiss.text = String(tablePosts[indexPath.row-1].love)
                cell.postNumOfWows.text = String(tablePosts[indexPath.row-1].wow)
                cell.postNumOfComments.text = "\(tablePosts[indexPath.row-1].comments) Comments"
                cell.postNumOfEmojis.text = String(tablePosts[indexPath.row-1].liked + tablePosts[indexPath.row-1].wow + tablePosts[indexPath.row-1].love)
                cell.postNumOfViews.text = "\(tablePosts[indexPath.row-1].views) View"
                
                let url = URLs.photoMain + tablePosts[indexPath.row-1].galleryFile
                cell.PostVideo?.configure(url: url)
                cell.soundImage.image = UIImage(named: "soundOff")
                cell.soundBtn = {
                    self.index1 = indexPath
                    print(indexPath)
                    cell.PostVideo.isLoop = true
                    if cell.PostVideo.checkCurrent(){
                        cell.PostVideo.pause()
                        
                        cell.soundImage.image = UIImage(named: "soundOff")
                    }else{
                        cell.PostVideo.play()
                        cell.soundImage.image = UIImage(named: "soundOn")
                    }
                }
                return cell
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let lastStory = collectionStories[index]
        if lastStory.background_type == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storiesVideoCell", for: indexPath) as! storiesVideoCell
            cell.configureCell(story: lastStory)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyHomeCollectionViewCell", for: indexPath) as! storyHomeCollectionViewCell
            cell.configureCell(story: lastStory)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 3
        let wid = width > 100 ? 100 : width
        return CGSize(width: wid, height: CGFloat(collectionView.bounds.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContentView") as! ContentViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.pages = self.collectionStories
            vc.currentIndex = indexPath.item
            self.present(vc, animated: true, completion: nil)
        }
    }
}
extension HomeVC: PhotoEditorDelegate {
    
    func doneEditing(image: UIImage) {
        self.picker_image = image
    }
    
    func canceledEditing() {
        self.showAlertWiring(title: "Image Not Selected")
        print("Canceled")
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePiker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picke = info[.mediaURL] as? URL{
            self.videoUrl = picke
            imagePiker.dismiss(animated: true, completion: nil)
        }else if let originalImage = info[.originalImage] as? UIImage {
            imagePiker.dismiss(animated: true, completion: nil)
            
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.image = originalImage
            //Colors for drawing and Text, If not set default values will be used
            //photoEditor.colors = [.red, .blue, .green]
            
            //Stickers that the user will choose from to add on the image
            for i in 0...10 {
                photoEditor.stickers.append(UIImage(named: i.description)!)
            }
            present(photoEditor, animated: true, completion: nil)
            //  self.picker_image = originalImage
        }
    }
}

extension HomeVC : GADBannerViewDelegate {
    /*
     lazy var adBannerView: GADBannerView = {
     let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
     adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
     adBannerView.delegate = self
     adBannerView.rootViewController = self
     
     return adBannerView
     }()
     */
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.userPostsTable.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.userPostsTable.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}
extension HomeVC : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        switch tabBarIndex {
        case 0:
            scrollToTob()
        default:
            print(tabBarIndex)
        }
    }
    
    private func scrollToTob(){
        if tablePosts.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.userPostsTable.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
