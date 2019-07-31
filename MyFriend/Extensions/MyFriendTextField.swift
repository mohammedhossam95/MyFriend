//
//  MyFriendTextField.swift
//  MyFriend
//
//  Created by MOHAMMED HOSSAM on 7/30/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Material
class MyFriendTextField: ErrorTextField {
    override func prepare() {
        super.prepare()
        self.dividerActiveColor = .lightGray
        self.errorColor = .red
        self.isErrorRevealed = true
        self.placeholderActiveColor = .darkGray
    }
}
