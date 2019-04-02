//
//  GallaryVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/11/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import CoreMedia
import Fusuma

class GallaryVC: BaseViewController {
    
    @IBOutlet weak var galleryCollection: UICollectionView!
    
    var preGallery = [GPhoto]()
    var gallery = [GPhoto]()
    var imagePiker: UIImagePickerController!
    var player: AVPlayer!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        preHandling()
        handleGalleryRefresh()
        galleryCollection.alwaysBounceVertical = true
        self.galleryCollection.addSubview(refresher)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getgalleryPostsSockets { (post: GPhoto) in
            DispatchQueue.main.async { [weak self] in
                if post.status != "false"{
                    
                    self?.preGallery.append(post)
                    self?.handleGalleryRefresh()
                }else {

                    let alertController = UIAlertController(title: "Something Error", message:  post.exception, preferredStyle: .alert)
                    let Confirm = UIAlertAction(title: "Try Again", style: .cancel)
                    alertController.addAction(Confirm)
                    self?.navigationController?.present(alertController, animated: true, completion: nil)

                }
            }
        }

    }
    var isLoading = false
    var current_page = 1
    var last_page = 1
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleGalleryRefresh), for: .valueChanged)
        return refresher
    }()
    func preHandling() {
        let bgGallery = helper.getUserbgGallery()
        let firstPost = GPhoto()
        if preGallery.isEmpty {
            firstPost.file = bgGallery!
            firstPost.type = "image"
            preGallery.insert(firstPost, at: 0)
        }else{
            self.preGallery.removeAll()
            firstPost.file = bgGallery!
            firstPost.type = "image"
            preGallery.insert(firstPost, at: 0)
        }
    }
    @objc func handleGalleryRefresh()  {
        showLoading()
       self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getGallery { (error: Error?, GPhotos: [GPhoto]?, last_page: Int) in
            self.isLoading = false
            self.preHandling()
            if let GPhotos = GPhotos{
                self.gallery = GPhotos
                self.preGallery.append(contentsOf: GPhotos)
                self.hideLoading()
                self.galleryCollection.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    
    fileprivate func LoadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true

        ApiCalls.getGallery(page: current_page+1) { (error: Error?, GPhotos: [GPhoto]?, last_page: Int) in
            self.isLoading = false
            if let GPhotos = GPhotos{
                self.gallery.append(contentsOf: GPhotos)
                self.preGallery.append(contentsOf: GPhotos)
                self.galleryCollection.reloadData()
                self.current_page += 1
                self.last_page = last_page
                
            }
        }
    }
    
    func openCamera() {
        imagePiker = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePiker.sourceType = UIImagePickerController.SourceType.camera
            imagePiker.delegate = self
            imagePiker.allowsEditing = true
            imagePiker.videoMaximumDuration = 40.0
            imagePiker.videoQuality = .typeMedium
            imagePiker.setEditing(true, animated: true)
            imagePiker.mediaTypes = ["public.image", "public.movie"]
            present(imagePiker, animated: true, completion: nil)
        }else {
            opengallery()
        }
    }
    func addMemory() {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "MemoriesVC") as! MemoriesVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func opengallery() {
        imagePiker = UIImagePickerController()
        imagePiker.allowsEditing = true
        imagePiker.sourceType = .photoLibrary
        imagePiker.videoMaximumDuration = 40.0
        imagePiker.videoQuality = .typeMedium
        imagePiker.setEditing(true, animated: true)
        imagePiker.mediaTypes = ["public.image", "public.movie"]
        imagePiker.delegate = self
        self.present(imagePiker, animated: true, completion: nil)
    }
    var picker_image: UIImage?{
        didSet{
            self.showLoading()
            guard let image = picker_image else { return }
            let uid = helper.getUserId()
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            let base64String =  imageData?.base64EncodedString(options: [])
            guard let base64 = base64String else { return }
            let base64String1 = "data:image/jpeg;base64,\(base64)"
            // print("the first photo is \(base64String1) the end")
            SocketIOManager.sharedInstance.sendVideoToServerSocket(user_id: uid!, text: "", fileBase64: base64String1, fileType: "image")
        }
    }

    private func handleDelete(story: GPhoto, indexPath: IndexPath) {
        self.showLoading()
        ApiCalls.DeleteGallery(photo: story) { (error: Error?, success : Bool, status: String) in
            if success {
                self.hideLoading()
                if let index = self.preGallery.firstIndex(of: story){
                    self.preGallery.remove(at: index)
                    self.galleryCollection.deleteItems(at: [indexPath])
                    self.galleryCollection.reloadData()
                }else{
                    print("Not available index")
                }
                
            }else {
                self.hideLoading()
                self.showAlertError(title: status)
                //print(error?.localizedDescription as Any)
            }
        }
    }
//    var videoUrl: URL?{
//        didSet{
//            self.showLoading()
//            guard let video = videoUrl else { return }
//            DispatchQueue.global(qos: .background).async {
//                print("This is run on the background queue")
//                ApiCalls.uploadGalleryVideo(avatar: video) { (error: Error?, success: Bool) in
//                    self.showLoading()
//                    if success {
//                        self.hideLoading()
//                        let alertController = UIAlertController(title: "Photo Update", message: "Your Photo was Updated Succesfully", preferredStyle: .alert)
//                        let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
//                            print("Cancel btn")
//                        }
//                        alertController.addAction(cancelBtn)
//
//                        self.navigationController?.present(alertController, animated: true, completion: nil)
//                    }else {
//                        let alertController = UIAlertController(title: "Try Again", message: "Upload Failure", preferredStyle: .alert)
//                        let cancelBtn = UIAlertAction(title: "OK", style: .cancel)
//                        alertController.addAction(cancelBtn)
//                        self.navigationController?.present(alertController, animated: true, completion: nil)
//
//                        self.hideLoading()
//                        print(error?.localizedDescription as Any)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.hideLoading()
//                    }
//
//            }
//        }
//    }
    
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
                let videoBase64String = videoData.base64EncodedString(options: .lineLength64Characters)
                let base64String1 = "data:video/mp4;base64,\(videoBase64String)"
                

                    //print(base64String1)
                SocketIOManager.sharedInstance.sendVideoToServerSocket(user_id: uid!, text: "", fileBase64: base64String1, fileType: "video")
                self.hideLoading()
                
            } catch let error{
                print(error.localizedDescription)

                }
            }
        }
    }
    
}

extension GallaryVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.galleryCollection.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! galleryCell
        let lastStory = preGallery[indexPath.row]
        if indexPath.item == 0 {
            cell.deleteimgBtn.isHidden = true
            cell.deleteimgBtn.isEnabled = false
        }else{
            cell.deleteimgBtn.isHidden = false
            cell.deleteimgBtn.isEnabled = true
        }
        cell.deletePost = {
            let alertController = UIAlertController(title: "Delete Photo", message: " ", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.handleDelete(story: lastStory, indexPath: indexPath)
            }
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(delete)
            alertController.addAction(cancelBtn)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
        if preGallery[indexPath.item].type == "image" {
            cell.galleryPhoto.isHidden = false
            cell.galleryVideo.isHidden = true
            
            cell.galleryPhoto.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + preGallery[indexPath.row].file)
            {
                cell.galleryPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }else{
            cell.galleryPhoto.isHidden = true
            cell.galleryVideo.isHidden = false
            
            //resetPlayer()
            if let url = URL(string: "\(URLs.photoMain)\(preGallery[indexPath.row].file)"){
                self.player = AVPlayer(url: url)
            }
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = cell.galleryVideo.bounds
            videoLayer.videoGravity = .resizeAspect
            cell.galleryVideo.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            cell.galleryVideo.layer.addSublayer(videoLayer)
            self.player.pause()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = indexPath.item
        if  cellType == 0 {
            
            let alertController = UIAlertController(title: "Choose Type", message: "Please select photo from Gallery or open Camera", preferredStyle: .actionSheet)
            
            let openGalleryBtn = UIAlertAction(title: "Open Gallery", style: .default) { (action) in
                self.opengallery()
            }
            
            let openCameraBtn = UIAlertAction(title: "Open camera", style: .default) { (action) in
                self.openCamera()
            }
            let addMemory = UIAlertAction(title: "Add Memory", style: .default) { (action) in
                self.addMemory()
            }
            
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(openGalleryBtn)
            alertController.addAction(openCameraBtn)
            alertController.addAction(addMemory)
            alertController.addAction(cancelBtn)
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }else {
            if  gallery[indexPath.row - 1].type == "video"{
                ApiCalls.getSinglePhoto(gallery_id: self.gallery[indexPath.row - 1].id) { (error: Error?, singleGallery: SingleGallery?) in
                    if let singleGallery = singleGallery{
                        print(singleGallery.galleryId)
                        if let url = URL(string: "\(URLs.photoMain)\(self.gallery[indexPath.row - 1].file)"){
                            let video = AVPlayer(url: url)
                            let videoPlayer = AVPlayerViewController()
                            videoPlayer.player = video
                            self.present(videoPlayer, animated: true, completion: {
                                video.play()
                            })
                        }
                    }
                }
                
                
                
            }else{
                let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
//                VC.post.galleryFile = gallery[indexPath.row - 1].file
//                VC.post.id = gallery[indexPath.row - 1].id
//                VC.post.type = gallery[indexPath.row - 1].type
//                VC.post.liked = gallery[indexPath.row - 1].liked
//                VC.post.love = gallery[indexPath.row - 1].love
//                VC.post.wow = gallery[indexPath.row - 1].wow
                //VC.post.hasLiked =
                 VC.gallery_id = gallery[indexPath.row - 1].id
                //self.navigationController?.pushViewController(VC, animated: true)
                self.navigationController?.present(VC, animated: true, completion: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = self.preGallery.count
        if indexPath.item == count-1 {
            self.LoadMore()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.bounds.width - 16) / 3), height: CGFloat((collectionView.bounds.width - 16) / 3))
    }
    
}
extension GallaryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picke = info[.mediaURL] as? URL{
            self.videoUrl = picke
        }
        else if let editedImage = info[.editedImage] as? UIImage{
            self.picker_image = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            self.picker_image = originalImage
        }
        imagePiker.dismiss(animated: true, completion: nil)
        
    }
}
