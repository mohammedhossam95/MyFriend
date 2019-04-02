//
//  PlayerVideoClass.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerVideoClass: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = .resizeAspect
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func checkCurrent() -> Bool {
        if player?.timeControlStatus == AVPlayer.TimeControlStatus.playing {
            return true
        }else{
            return false
        }
    }
    func pause() {
        player?.pause()
    }
    func Mute() {
        player?.isMuted = true
    }
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
class PlayerVideoAspectClass: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(url: String, bound: CGRect) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bound
            playerLayer?.videoGravity = .resizeAspectFill
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func checkCurrent() -> Bool {
        if player?.timeControlStatus == AVPlayer.TimeControlStatus.playing {
            return true
        }else{
            return false
        }
    }
    func pause() {
        player?.pause()
    }
    func Mute() {
        player?.isMuted = true
    }
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

