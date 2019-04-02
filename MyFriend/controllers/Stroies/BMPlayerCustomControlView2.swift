//
//  BMPlayerCustomControlView2.swift
//  BMPlayer
//
//  Created by BrikerMan on 2017/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import BMPlayer

class BMPlayerCustomControlView2: BMPlayerControlView {
    
    var mySensitiveArea = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.height)
//    var playTimeUIProgressView = UIProgressView()
//   var playingStateLabel = UILabel()
    
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        // just make the view hidden
        topMaskView.isHidden = true
        chooseDefinitionView.isHidden = true
        
        // or remove from superview
        playButton.removeFromSuperview()
        currentTimeLabel.removeFromSuperview()
        totalTimeLabel.removeFromSuperview()
        
        timeSlider.removeFromSuperview()
        fullscreenButton.removeFromSuperview()
    }
    
    override func updateUI(_ isForFullScreen: Bool) {
        topMaskView.isHidden = true
        chooseDefinitionView.isHidden = true
    }
    
    override func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
      //  playTimeUIProgressView.setProgress(Float(currentTime/totalTime), animated: true)
    }

    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        // redirect tap action to play button action
       // delegate?.controlView(controlView: self, didPressButton: playButton)
        let p = gesture.location(in: self.player)
        if mySensitiveArea.contains(p) {
            PreViewController.SPB.rewind()
        }
        else {
            PreViewController.SPB.skip()
        }
    }
    
    override func playStateDidChange(isPlaying: Bool) {
        super.playStateDidChange(isPlaying: isPlaying)
       // playingStateLabel.text = isPlaying ? "Playing" : "Paused"
    }
    
    override func controlViewAnimation(isShow: Bool) {
    }
}
