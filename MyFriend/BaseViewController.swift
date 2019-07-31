//
//  BaseViewController.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/17/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftMessages
import AVFoundation
import SCLAlertView

class BaseViewController: UIViewController {

    //MARK: Alerts
    func showAlertWiring(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.warning)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 1)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    func showAlertError(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.error)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 1)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    func showAlertsuccess(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.success)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 1)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    
    
    //MARK: Loading View
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showLoading() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            
            overlayView.backgroundColor = UIColor.clear
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator.style = .whiteLarge
            activityIndicator.color = .red
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            overlayView.addSubview(activityIndicator)
            window.addSubview(overlayView)
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    var overlayView2 = UIView()
    var activityIndicator2 = UIActivityIndicatorView()
    
    func showSpecificLoading() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            let height = window.frame.height >= 812 ? window.frame.height - 82.6 : window.frame.height-49.6
            overlayView2.frame = CGRect(x:0, y:0, width: window.frame.width , height: height)
            overlayView2.backgroundColor = UIColor.white
            overlayView2.clipsToBounds = true
            overlayView2.layer.cornerRadius = 10
            activityIndicator2.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator2.style = .whiteLarge
//            activityIndicator2.color = .red
            activityIndicator2.center = CGPoint(x: overlayView2.bounds.width / 2, y: overlayView2.bounds.height / 2)
            overlayView2.addSubview(activityIndicator2)
            window.addSubview(overlayView2)
            activityIndicator2.startAnimating()
        }
    }
    
    func hideSpecificLoading() {
        activityIndicator2.stopAnimating()
        overlayView2.removeFromSuperview()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideLoading()
        hideSpecificLoading()
    }
}

class BaseTableViewController: UITableViewController {
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showSpecificLoading() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            overlayView.frame = CGRect(x:0, y:0, width: window.frame.width , height: window.frame.height)
            overlayView.backgroundColor = UIColor.white
            activityIndicator.frame = CGRect(x:0, y:0, width:60, height:60)
            activityIndicator.style = .whiteLarge
            activityIndicator.color = UIColor(hexString: "F78161")
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            overlayView.addSubview(activityIndicator)
            window.addSubview(overlayView)
            activityIndicator.startAnimating()
        }
    }
    
    func hideSpecificLoading() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideLoading()
        hideSpecificLoading()
    }
    
    var overlayView1 = UIView()
    var activityIndicator1 = UIActivityIndicatorView()
    
    func showLoading() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            
            let height = window.frame.height >= 812 ? window.frame.height - 82.6 : window.frame.height-49.6
            overlayView1.frame = CGRect(x:0, y:0, width: window.frame.width , height: height)
            overlayView1.backgroundColor = UIColor.white
            activityIndicator1.frame = CGRect(x:0, y:0, width:60, height:60)
            activityIndicator1.style = .whiteLarge
            activityIndicator1.color = UIColor(hexString: "F78161")
            activityIndicator1.center = CGPoint(x: overlayView1.bounds.width / 2, y: overlayView1.bounds.height / 2)
            overlayView1.addSubview(activityIndicator1)
            window.addSubview(overlayView1)
            activityIndicator1.startAnimating()
        }
    }
    
    func hideLoading() {
        activityIndicator1.stopAnimating()
        overlayView1.removeFromSuperview()
    }
    
}
