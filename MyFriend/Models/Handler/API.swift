//
//  API.swift
//  LimozeinSW
//
//  Created by Khaled Saad on 10/22/17.
//  Copyright © 2017 Khaled Saad. All rights reserved.
//

import UIKit
import Alamofire

typealias Handler = (_ response:Any? ,_ error:String?) -> Void

class API: NSObject {
    
//    class func login(email : String ,password: String,completion :@escaping Handler) {
//
//        var token = "none"
//
//        if let string = Cache.object(key: Constants.deviceToken) {
//            token = string as! String
//        }
//
//        let udid = UIDevice.current.identifierForVendor!.uuidString
//
//        let body = ["Email":email,"Password":password,"DeviceType":"IPhone","SN":udid,"Token":token,"CustomerTypes":Cache.object(key: Constants.loginType) as! String]
//
//
//        APIClient.request(path: "Customer/UserLogin", method: .post, params: body , header: nil, model: QLUser(), completionHandler: completion)
//
//
//    }
   

    
}


