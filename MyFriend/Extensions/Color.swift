//
//  Color.swift
//  CCHIMajlis
//
//  Created by Mohamed Tarek on 8/9/17.
//  Copyright © 2017 asgatech. All rights reserved.
//

import UIKit

extension UIColor {
    func getRandom() -> UIColor {
        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }
    private func random() -> CGFloat {
        return CGFloat(arc4random_uniform(255))/255.0
    }
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.utf8.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    // get hex string from color
    enum HexFormat {
        case RGB
        case ARGB
        case RGBA
        case RRGGBB
        case AARRGGBB
        case RRGGBBAA
    }
    
    enum HexDigits {
        case d3, d4, d6, d8
    }
    
    func hex1String(_ format: HexFormat = .RRGGBBAA) -> String {
        let maxi = [.RGB, .ARGB, .RGBA].contains(format) ? 16 : 256
        
        func toI(_ f: CGFloat) -> Int {
            return min(maxi - 1, Int(CGFloat(maxi) * f))
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let ri = toI(r)
        let gi = toI(g)
        let bi = toI(b)
        let ai = toI(a)
        
        switch format {
        case .RGB:       return String(format: "#%X%X%X", ri, gi, bi)
        case .ARGB:      return String(format: "#%X%X%X%X", ai, ri, gi, bi)
        case .RGBA:      return String(format: "%X%X%X%X", ri, gi, bi, ai)
        case .RRGGBB:    return String(format: "%02X%02X%02X", ri, gi, bi)
        case .AARRGGBB:  return String(format: "#%02X%02X%02X%02X", ai, ri, gi, bi)
        case .RRGGBBAA:  return String(format: "#%02X%02X%02X%02X", ri, gi, bi, ai)
        }
    }
    
    func hex1String(_ digits: HexDigits) -> String {
        switch digits {
        case .d3: return hex1String(.RGB)
        case .d4: return hex1String(.RGBA)
        case .d6: return hex1String(.RRGGBB)
        case .d8: return hex1String(.RRGGBBAA)
        }
    }
}


extension CGColor {
    class func colorWithHex(hex: String) -> CGColor {
        
        return UIColor(hexString: hex).cgColor
    }
}
