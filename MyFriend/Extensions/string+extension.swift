//
//  string+extension.swift
//  MyFriend
//
//  Created by hossam Adawi on 12/31/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import SwiftMoment

extension String {
    
        func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return ceil(boundingBox.height)
        }
        
        func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return ceil(boundingBox.width)
        }
        
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    func toDateTime() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    
    
    func toDateOnly() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    
    
    
    
    func toDate() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        print(self)
        
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    func toGregorianDate() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        print(self)
        
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    func toHijriDate() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        print(self)
        
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    
    
    
    func toTime() -> Date {
        //Create Date Formatter
        let timeFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        timeFormatter.dateFormat = "hh:mm:ss"
        
        //Parse into NSDate
        let timeFromString : Date = timeFormatter.date(from: self)!
        
        //Return Parsed Date
        return timeFromString
    }
    
    var isValidEmail: Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        
        if self.count == 9 || self.count == 11 {
            return true
        }
        
        return false
        
    }
    
    public var initials: String {
        
        var finalString = String()
        var words = components(separatedBy: .whitespacesAndNewlines)
        
        if let firstCharacter = words.first?.first {
            finalString.append(String(firstCharacter))
            words.removeFirst()
        }
        
        if let lastCharacter = words.last?.first {
            finalString.append(String(lastCharacter))
        }
        
        return finalString.uppercased()
    }
    
    var intValue : Int {
        
        let arr = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        
        var result = self
        
        for int in 0...9 {
            result = result.replacingOccurrences(of: arr[int], with:String(int) )
        }
        result = result.replacingOccurrences(of: " \("SAR".localized)", with:"" )
        
        if let value = Int(result) {
            return value
        } else {
            return 0
        }
        
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var englishPhoneNumber : String {
        
        let arr = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        
        var result = self
        
        for int in 0...9 {
            result = result.replacingOccurrences(of: arr[int], with:String(int) )
        }
        
        return result
    }
    
    var timestamp: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self) ?? Date()
    }
}
