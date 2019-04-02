//
//  UIFontExensions.swift
//  Challenge_App
//
//  Created by Khaled saad on 1/23/18.
//  Copyright © 2018 Asgatech. All rights reserved.
//

import UIKit

extension UIFont {
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
