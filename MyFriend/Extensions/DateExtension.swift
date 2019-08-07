//
//  NSDateExtension.swift
//  AlMokhtabar
//
//  Created by Mohamed Tarek on 1/25/17.
//  Copyright © 2017 Yackeen Solutions. All rights reserved.
//

import Foundation

extension Date {

    struct Date_ {
        static let formatter = DateFormatter()
    }
    
    
    func CalederStyle(calender:Calendar.Identifier){
        
        let calender = Calendar.init(identifier: calender)
        Date_.formatter.calendar=calender
 
    }
    var dateString: String {
        Date_.formatter.dateFormat = "yyyy-MM-dd"
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        CalederStyle(calender: Calendar.Identifier.gregorian)
        
        return Date_.formatter.string(from: self)
    }
    
    
    
    
    
    var dayString: String {
        Date_.formatter.dateFormat = "d"
       // Date_.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        Date_.formatter.locale = Locale(identifier: "en_US")
        return Date_.formatter.string(from: self)
    }
    
    var dayNameString: String {
        Date_.formatter.dateFormat = "EE"
//        Date_.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        return Date_.formatter.string(from: self)
    }
    
    var dayMonthString: String {
        Date_.formatter.dateFormat = "EEEE, MMMM"
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        return Date_.formatter.string(from: self)
    }
    
    var dateStr: String {
        Date_.formatter.dateFormat = "MM-dd-yyyy"
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        return Date_.formatter.string(from: self)
    }
    
    var monthString: String {
        Date_.formatter.dateFormat = "MM"
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        return Date_.formatter.string(from: self)
    }
    
    var yearString: String {
        Date_.formatter.dateFormat = "yyyy"
        Date_.formatter.locale = Locale(identifier: "en_US")
        
        return Date_.formatter.string(from: self)
    }
    
    var timeString: String {
        Date_.formatter.dateFormat = "h:mm a"//"HH:mm"
        Date_.formatter.amSymbol = "AM"
        Date_.formatter.pmSymbol = "PM"
        Date_.formatter.locale = Locale(identifier: "en_US")
        return Date_.formatter.string(from: self)
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self) == ComparisonResult.orderedDescending) // deadline is earlier than current date
    }
    
    var isEqualCurrentDate: Bool{
        return (NSDate().compare(self) == ComparisonResult.orderedSame)
    }
}



