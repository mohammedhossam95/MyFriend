//
//  TableView+Extension.swift
//  MyFriend
//
//  Created by MOHAMED HAMAD on 7/30/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadDataAnimatedKeepingOffset()
    {
        let offset = contentOffset
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        UIView.setAnimationsEnabled(true)
        layoutIfNeeded()
        contentOffset = offset
    }
}
