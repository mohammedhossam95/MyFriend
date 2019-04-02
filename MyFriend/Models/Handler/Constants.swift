//
//  Constants.swift
//  Naqelat
//
//  Created by Mahmoud El-Sayed on 9/13/17.
//  Copyright © 2017 Asgatech. All rights reserved.
//

import UIKit

struct Constants {
    static let deviceType = "IPhone"
    // for testing
    static let userDemoAuth = "user_auth dXNlcl9pZDo0MSx1c2VybmFtZTonTWFobW91ZEVpc3NhJyxlbWFpbDonZGVtb0B1c2VyLmNvbScsaXNzdWVkX29uOjYzNjQ4MTgwMzE3MTI1MjQ3NSxleHBpcmVzX29uOjYzNjUwNzcyMzE3MTI1MjQ3NQ=="
    static let providerDemoAuth = "user_auth dXNlcl9pZDo1Myx1c2VybmFtZTonRGVtb1Byb3ZpZGVyJyxlbWFpbDonZGVtb0Bwcm92aWRlci5jb20nLGlzc3VlZF9vbjo2MzY0ODE3MzAzMDc5MDcyMzgsZXhwaXJlc19vbjo2MzY1MDc2NTAzMDc5MDcyMzg="
    
    static let deviceToken = "deviceToken"
    static let baseUrl = "http://46.151.215.164:29875/api/V1/"
//    static let baseUrl = "http://192.168.1.7:8070/api/V1/"
    static let loginType = "loginType"
    
    static let customerType = 0
    static let serviceProviderType = 1
    static let currentUser = "currentUser"
    static let currentRequest = "currentRequest"
    static let dateSort = "Date"
    static let rateSort = "Rating"
    static let priceSort = "Price"
    static let dateFormat = "yyyy-MM-dd"
    static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let grayHexCode = "#5F5B5C"
    static let yellowHexCode = "#FAA40E"

    static let webSiteLink = "http://www.google.com"
    static let faceBookLink = "http://www.facebook.com"
    static let twitterLink = "http://www.twitter.com"
    static let appVersion = "Version 1.0"
    
    static let phone = "01200000000"
    static let email = "info@info.com"
    static let address = "26th of July Corridor, Giza Governorate"


    static let latitude = 30.0062808
    static let longitude = 30.9034403

}

enum RequestState : String {

    case Open       = "1"
    case Accepted   = "2"
    case Closed     = "3"
    case Cancelled  = "4"
    case Rejected   = "5"
    case Expired    = "6"


}
enum ProposalState : String {
    
    case Open       = "1"
    case Accepted   = "2"
    case Closed     = "3"
    case Cancelled  = "4"
    case Rejected   = "5"
    case Expired    = "6"
    
    
}
enum OfferState : String {
    
    case Accepted   = "1"
    case Done     = "2"
    case Rejected   = "3"
    
}




