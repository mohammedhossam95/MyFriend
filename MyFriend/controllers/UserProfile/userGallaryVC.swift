//
//  userGallaryVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/26/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import AVFoundation

class userGallaryVC: BaseViewController {
    
    @IBOutlet weak var galleryCollection: UICollectionView!
    
    var gallery = [GPhoto]()
    
    let firstPost = GPhoto()
    
    var isLoading = false
    static var id: Int = 0
    var player: AVPlayer!
    
    var current_page = 1
    var last_page = 1
    
    //    lazy var refresher: UIRefreshControl = {
    //        let refresher = UIRefreshControl()
    //        refresher.addTarget(self, action: #selector(handleGalleryRefresh), for: .valueChanged)
    //        return refresher
    //    }()
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleGalleryRefresh(friend_id: userGallaryVC.id)
        galleryCollection.alwaysBounceVertical = true
    }
    
    
    @objc func handleGalleryRefresh(friend_id: Int)  {
        showSpecificLoading()
        //  self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getFriendGallery(friend_id: friend_id) { (error: Error?, GPhotos: [GPhoto]?, last_page: Int) in
            self.isLoading = false
            if let GPhotos = GPhotos{
                if GPhotos.isEmpty {
                    self.galleryCollection.isHidden = true
                    self.hideLoading()
                    self.hideSpecificLoading()
                }else{
                    self.gallery = GPhotos
                    self.hideSpecificLoading()
                    self.galleryCollection.reloadData()
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
        
        ApiCalls.getGallery(page: current_page+1) { (error: Error?, GPhotos: [GPhoto]?, last_page: Int) in
            self.isLoading = false
            if let GPhotos = GPhotos{
                
                //self.tablePosts = posts
                self.gallery.append(contentsOf: GPhotos)
                self.galleryCollection.reloadData()
                self.current_page += 1
                self.last_page = last_page
                
            }
        }
    }
    
    
}
extension userGallaryVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = self.gallery.count
        if indexPath.item == count-1 {
            self.LoadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.galleryCollection.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! galleryCell
        
        //let photo = indexPath.row - 1
        if gallery[indexPath.item].type == "image" {
            cell.galleryPhoto.isHidden = false
            cell.galleryVideo.isHidden = true
            cell.galleryPhoto.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + gallery[indexPath.row].file) {
                cell.galleryPhoto.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }else{
            cell.galleryPhoto.isHidden = true
            cell.galleryVideo.isHidden = false
            
            //resetPlayer()
            if let url = URL(string: "\(URLs.photoMain)\(gallery[indexPath.row].file)"){
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
        if  gallery[indexPath.item].type == "video"{
            ApiCalls.getSinglePhoto(gallery_id: self.gallery[indexPath.item].id) { (error: Error?, singleGallery: SingleGallery?) in
                if let singleGallery = singleGallery{
                    print(singleGallery.galleryId)
                    if let url = URL(string: "\(URLs.photoMain)\(self.gallery[indexPath.item].file)"){
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
            //            VC.post.galleryFile = gallery[indexPath.item].file
            //            VC.post.id = gallery[indexPath.item].id
            //            VC.post.type = gallery[indexPath.item].type
            //            VC.post.liked = gallery[indexPath.item].liked
            //            VC.post.love = gallery[indexPath.item].love
            //            VC.post.wow = gallery[indexPath.item].wow
            
            VC.gallery_id = gallery[indexPath.item].id
            self.navigationController?.present(VC, animated: true, completion: nil)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.bounds.width - 16) / 3), height: CGFloat((collectionView.bounds.width - 16) / 3))
    }
    
}
