//
//  TodayVC.swift
//  MyFriend
//
//  Created by hossam Adawi on 2/25/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Charts

class TodayVC: BaseViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var horBarChart: HorizontalBarChartView!
    @IBOutlet weak var numProfileViews: UILabel!
    @IBOutlet weak var profileViewsText: UILabel!
    @IBOutlet weak var numOfWows: UILabel!
    @IBOutlet weak var textOfWows: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var ageBtn: UIButton!
    
    var follows     = [FollowRatio]()
    var insights    = [Insight]()
    var profileAges = [AgeGroup]()
    var followAges  = [AgeGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handleTodayAnalysis()
    }
    
    
    @IBAction func profile_update(_ sender: UIButton) {
        profileBtn.setTitleColor(UIColor.red, for: .normal)
        ageBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.updateAgeProfile(AgeProfileNum: self.profileAges)
    }
    
    @IBAction func woows_Update(_ sender: UIButton) {
        ageBtn.setTitleColor(UIColor.red, for: .normal)
        profileBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.updateAgeFollows(AgeFolllowsNum: self.followAges)
    }
    
    @objc func handleTodayAnalysis()  {
        self.showLoading()
        ApiCalls.GetTodayAnalysis { (error: Error?, insights: [Insight]?, followRatio: [FollowRatio]?, ageGroupProfile: [AgeGroup]?, AgeGroupWows: [AgeGroup]?) in
            if error == nil {
                if let profileInsights = insights {
                    self.insights = profileInsights
                    self.updateInights(insightsNum: self.insights)
                }
                if let profileInsights = followRatio {
                    self.follows = profileInsights
                    self.updateFollows(insightsNum: self.follows)
                }
                if let profileInsights = ageGroupProfile {
                    self.profileAges = profileInsights
                    self.updateAgeProfile(AgeProfileNum: self.profileAges)
                }
                if let profileInsights = AgeGroupWows {
                    self.followAges = profileInsights
                }
                self.hideLoading()
            }else {
                self.hideLoading()
                self.showAlertError(title: "Try Again Later")
            }
        }
    }
    
    func updateInights(insightsNum: [Insight])  {
        self.numProfileViews.text = String(insightsNum[0].value)
        self.profileViewsText.text = insightsNum[0].benefits
        self.numOfWows.text = String(insightsNum[1].value)
        self.textOfWows.text = insightsNum[1].benefits
    }
    
    func updateFollows(insightsNum: [FollowRatio])  {
        
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(insightsNum[0].profilesviews))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(0))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(0))
        let entry4 = BarChartDataEntry(x: 4.0, y: Double(0))
        let entry5 = BarChartDataEntry(x: 5.0, y: Double(0))
        let entry6 = BarChartDataEntry(x: 6.0, y: Double(0))
        let entry7 = BarChartDataEntry(x: 7.0, y: Double(0))
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7], label: "Today Report")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        
        dataSet.colors = [UIColor.red]
        
        barChart.legend.font = UIFont(name: "Futura", size: 17)!
        barChart.chartDescription?.font = UIFont(name: "Futura", size: 17)!
        barChart.animate(xAxisDuration: 3, yAxisDuration: 3)
        
        barChart.notifyDataSetChanged()
    }
    
    func updateAgeProfile(AgeProfileNum: [AgeGroup])  {
        
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(AgeProfileNum[0].value))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(AgeProfileNum[1].value))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(AgeProfileNum[2].value))
        let entry4 = BarChartDataEntry(x: 4.0, y: Double(AgeProfileNum[3].value))
        let entry5 = BarChartDataEntry(x: 5.0, y: Double(AgeProfileNum[4].value))
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5], label: "Age Profile")
        let data = BarChartData(dataSets: [dataSet])
        
        horBarChart.data = data
        
        dataSet.colors = [UIColor.red]
        
        horBarChart.legend.textColor = .black
        horBarChart.chartDescription?.textAlign = NSTextAlignment.right
        horBarChart.legend.font = UIFont(name: "Futura", size: 17)!
        horBarChart.chartDescription?.font = UIFont(name: "Futura", size: 17)!
        horBarChart.animate(xAxisDuration: 3, yAxisDuration: 3)
        
        horBarChart.notifyDataSetChanged()
    }
    
     private func updateAgeFollows(AgeFolllowsNum: [AgeGroup])  {
        
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(AgeFolllowsNum[0].value))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(AgeFolllowsNum[1].value))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(AgeFolllowsNum[2].value))
        let entry4 = BarChartDataEntry(x: 4.0, y: Double(AgeFolllowsNum[3].value))
        let entry5 = BarChartDataEntry(x: 5.0, y: Double(AgeFolllowsNum[4].value))
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5], label: "Age Profile")
        let data = BarChartData(dataSets: [dataSet])
        
        horBarChart.data = data
        
        dataSet.colors = [UIColor.red]
        
        horBarChart.legend.textColor = .black
        horBarChart.chartDescription?.textAlign = NSTextAlignment.right
        horBarChart.legend.font = UIFont(name: "Futura", size: 17)!
        horBarChart.chartDescription?.font = UIFont(name: "Futura", size: 17)!
        horBarChart.animate(xAxisDuration: 3, yAxisDuration: 3)
        
        horBarChart.notifyDataSetChanged()
    }
}
