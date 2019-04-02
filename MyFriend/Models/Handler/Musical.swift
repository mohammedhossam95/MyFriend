//
//  Musical.swift
//  Copoonz
//
//  Created by Eman Zayan on 6/23/18.
//  Copyright © 2018 Eman Zayan. All rights reserved.
//

import Foundation
import AVFoundation

class Musical :NSObject {
    var player: AVAudioPlayer?
    static let shared = Musical()
    
    override init() {
        super.init()
    }
    
    func playSound(_ num:Int) {
        var sourceName = ""
        if num == 1 {
            sourceName = "like"
        }else {
            sourceName = "dislike"
        }
        guard let url = Bundle.main.url(forResource: sourceName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
