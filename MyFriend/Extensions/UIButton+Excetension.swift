//
//  UIButton+Excetension.swift
//  ButtonAnimation
//
//  Created by MacBook Pro on 12/24/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
extension UIButton{
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.4
        
        layer.add(pulse, forKey: nil)
    }

    func flash() {
        let flash = CASpringAnimation(keyPath: "opacity")
        flash.duration = 0.6
        flash.fromValue = 0.95
        flash.toValue = 1.0
        flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        //flash.initialVelocity = 0.5
       // flash.damping = 1.4
        
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.6
        shake.autoreverses = true
        shake.repeatCount = 2
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        shake.fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint  = CGPoint(x: center.x + 5, y: center.y)
        shake.toValue = NSValue(cgPoint: toPoint)
        
        layer.add(shake, forKey: nil)
    }
    
    
    func animate(sender: UIButton) {
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }

    
}
