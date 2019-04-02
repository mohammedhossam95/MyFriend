//
//  AnalysisVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 2/25/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class AnalysisVC: UIViewController {
    
    @IBOutlet weak var todayCV: UIView!
    @IBOutlet weak var thisWeekCV: UIView!
    @IBOutlet weak var thisMonthCV: UIView!
    @IBOutlet weak var allTimeCV: UIView!
    
    @IBOutlet weak var today: UIButton!
    @IBOutlet weak var thisWeek: UIButton!
    @IBOutlet weak var thisMonth: UIButton!
    @IBOutlet weak var allTime: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShowContainerView()
        todayCV.isHidden = false
        today.setTitleColor(UIColor.red, for: .normal)
        today.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func display_today(_ sender: UIButton) {
        self.ShowContainerView()
        todayCV.isHidden = false
        today.setTitleColor(UIColor.red, for: .normal)
        today.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func display_thisWeek(_ sender: UIButton) {
        self.ShowContainerView()
        thisWeekCV.isHidden = false
        thisWeek.setTitleColor(UIColor.red , for: .normal)
        thisWeek.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
    }
    
    @IBAction func display_thisMonth(_ sender: UIButton) {
        self.ShowContainerView()
        thisMonthCV.isHidden = false
        thisMonth.setTitleColor(UIColor.red, for: .normal)
        thisMonth.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
    }
    
    @IBAction func display_allTime(_ sender: UIButton) {
        self.ShowContainerView()
        allTimeCV.isHidden = false
        allTime.setTitleColor(UIColor.red, for: .normal)
        allTime.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    func ShowContainerView() {
        
        todayCV.isHidden = true
        thisWeekCV.isHidden = true
        thisMonthCV.isHidden = true
        allTimeCV.isHidden = true
        
        today.setTitleColor(UIColor.lightGray , for: .normal)
        thisWeek.setTitleColor(UIColor.lightGray , for: .normal)
        thisMonth.setTitleColor(UIColor.lightGray, for: .normal)
        allTime.setTitleColor(UIColor.lightGray, for: .normal)
        
        today.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        thisWeek.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        thisMonth.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        allTime.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
    }
    
}
