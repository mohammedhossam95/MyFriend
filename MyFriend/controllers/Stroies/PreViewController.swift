//
//  PreViewController.swift
//  ARStories
//
//  Created by Antony Raphel on 05/10/17.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import Kingfisher
import BMPlayer

class PreViewController: UIViewController, SegmentedProgressBarDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var pageIndex : Int = 0
    var mySensitiveArea: CGRect?
    
    var items: [data] = []
    var item = [content]()
    static var SPB: SegmentedProgressBar!
    var player: BMPlayer!
    let loader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        userProfileImage.imageFromServerURL(items[pageIndex].avatar)
        lblUserName.text = items[pageIndex].name
        item = items[pageIndex].content!
        
        
        PreViewController.SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5.0)
        if #available(iOS 11.0, *) {
            PreViewController.SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            PreViewController.SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        PreViewController.SPB.delegate = self
        PreViewController.SPB.topColor = UIColor.white
        PreViewController.SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        PreViewController.SPB.padding = 2
        PreViewController.SPB.isPaused = true
        PreViewController.SPB.currentAnimationIndex = 0
        PreViewController.SPB.duration = getDuration(at: 0)
        view.addSubview(PreViewController.SPB)
        view.bringSubviewToFront(PreViewController.SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGestureImage)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        mySensitiveArea = CGRect(x: 0, y: 0, width: screenWidth / 2, height: screenHeight)
        
//
//        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn))
//        tapGestureVideo.numberOfTapsRequired = 1
//        tapGestureVideo.numberOfTouchesRequired = 1
//        videoView.addGestureRecognizer(tapGestureVideo)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        // longPressRecognizer.minimumPressDuration = 1.0
        if player != nil {
            player.addGestureRecognizer(longPressRecognizer)
        }else{
            videoView.addGestureRecognizer(longPressRecognizer)
        }
        
        
        let longPressRecognizerimage = UILongPressGestureRecognizer(target: self, action: #selector(longImagePressed))
       //  longPressRecognizer.minimumPressDuration = 1.0
        imagePreview.addGestureRecognizer(longPressRecognizerimage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playVideoOrLoadImage(index: 0)
            PreViewController.SPB.startAnimation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            PreViewController.SPB.currentAnimationIndex = 0
            PreViewController.SPB.cancel()
            PreViewController.SPB.isPaused = true
            self.resetPlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - SegmentedProgressBarDelegate
    //1
    func segmentedProgressBarChangedIndex(index: Int) {
        if self.player != nil {
            self.player.pause()
        }
        playVideoOrLoadImage(index: index)
    }
    
    //2
    func segmentedProgressBarFinished() {
        if pageIndex == (self.items.count - 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        //Function for determining when swipe gesture is in/outside of touchable area
        let p = sender.location(in: self.imagePreview)
        if mySensitiveArea!.contains(p) {
            PreViewController.SPB.rewind()
        }
        else {
            PreViewController.SPB.skip()
        }
    }
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            PreViewController.SPB.isPaused = true
            self.player.pause()
        case .ended:
            PreViewController.SPB.isPaused = false
            self.player.play()
        default:
            print("change4444")
            break
        }
    }
    //if sender.state == .changed &&
    @objc func longImagePressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            PreViewController.SPB.isPaused = true
        case .ended:
            PreViewController.SPB.isPaused = false
        default:
            print("change4444")
            break
        }
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        guard let type = item[index].type  else { return }
        if type == "image" || type == "text" {
            PreViewController.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            guard let imgeUrl = item[index].file  else { return }
            if let url = URL(string: "\(URLs.photoMain)\(imgeUrl)"){
                self.imagePreview.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
        } else {
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            
            resetPlayer()
            
            guard let url = URL(string: URLs.photoMain + item[index].file!) else {return}
            preparePlayer()
            setupPlayerResource(url: url)
        }
        
    }
    
    // MARK: Private func
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 3.0
        if item[index].type == "image" || item[index].type == "text" {
            retVal = 5.0
        } else {
            guard let url = URL(string: URLs.photoMain + item[index].file!) else { return retVal }
            let asset = AVAsset(url: url)
            let duration = asset.duration
            print(duration)
            retVal = CMTimeGetSeconds(duration)
        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            //player.avPlayer.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if self.player != nil{
            self.player.pause()
        }
        resetPlayer()
    }
    
    func preparePlayer() {
        player = BMPlayer(customControlView: BMPlayerCustomControlView2())

        videoView.addSubview(player)
        
        player.snp.makeConstraints { (make) in
            make.top.equalTo(videoView.snp.top)
            make.left.equalTo(videoView.snp.left)
            make.right.equalTo(videoView.snp.right)
            make.height.equalTo(videoView.snp.height)
        }
        player.delegate = self
        self.view.layoutIfNeeded()
    }
    
    func setupPlayerResource(url: URL) {
        player.videoGravity = .resizeAspect
        let asset = BMPlayerResource(url: url)
        
        let asset1 = AVAsset(url: url)
        let duration = asset1.duration
        let durationTime = CMTimeGetSeconds(duration)
        
        PreViewController.SPB.duration = durationTime
        player.setVideo(resource: asset)
        
        
    }
}
// MARK:- BMPlayerDelegate example
extension PreViewController: BMPlayerDelegate {
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
        if state == .buffering || state == .error || state == .readyToPlay || state == .notSetURL{
            PreViewController.SPB.isPaused = true
        }else if state == .bufferFinished {
            PreViewController.SPB.isPaused = false
        }else {
            PreViewController.SPB.isPaused = false
            PreViewController.SPB.skip()
        }
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
