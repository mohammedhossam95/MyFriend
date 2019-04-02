//
//  EmojiVC.swift
//  MyFriend
//
//  Created by Mohammed Hossam on 2/5/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class EmojiVC: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var btnAdmin: UIButton!
    @IBOutlet weak var btnProjects: UIButton!
    @IBOutlet weak var btnTechSup: UIButton!
    
    // Container Views
    @IBOutlet weak var ContViewChats: UIView!
    @IBOutlet weak var ContViewProjects: UIView!
    @IBOutlet weak var ContViewTechSup: UIView!
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beforChangeHappend()
        ContViewProjects.isHidden = false
    }
    
    // MARK: Buttons Actions
    
    @IBAction func backMenu(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdminClick(_ sender: UIButton) {
        self.beforChangeHappend()
        ContViewChats.isHidden = false
        
    }
    
    @IBAction func btnTechSupClick(_ sender: UIButton) {
        
        self.beforChangeHappend()
        ContViewTechSup.isHidden = false
    }
    
    @IBAction func btnProjectsClicks(_ sender: UIButton) {
        self.beforChangeHappend()
        ContViewProjects.isHidden = false
    }
    
    // MARK: Func of all views in controller
    
    func beforChangeHappend() -> Void {
        ContViewChats.isHidden = true
        ContViewProjects.isHidden = true
        ContViewTechSup.isHidden = true
    }

}
