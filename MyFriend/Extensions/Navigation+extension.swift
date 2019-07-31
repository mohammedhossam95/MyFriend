//
//  Navigation+extension.swift
//  MyFriend
//
//  Created by MOHAMED HAMAD on 7/30/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationController {
    func popToViewController(backIndex : Int , animated : Bool)  {
        
        let index = self.viewControllers.count - backIndex - 1
        self.popToViewController(self.viewControllers[index], animated: animated)
        
    }

}
