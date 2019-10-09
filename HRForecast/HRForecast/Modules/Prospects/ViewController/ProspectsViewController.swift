//
//  ProspectsViewController.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import Charts

class ProspectsViewController: BaseViewController, UIBroker {
    
    var payLoad: [String : Any]?

    @IBOutlet weak var chartView: BarChartView!
    
    lazy var viewModel = ProspectsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = DashboardConstants.title
        
        showActivityIndicator()
        viewModel.getProspects {[weak self] (error) in
            self?.hideActivityIndicator()
            self?.updateChartData()
        }
        
        chartView.chartDescription?.enabled = false
                
        chartView.maxVisibleCount = 40
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
    }
    
    func updateChartData() {
        self.setChartData(count: Int(6), range: UInt32(20))
    }
    
    func setChartData(count: Int, range: UInt32) {
       let yVals = (0..<count).map { (i) -> BarChartDataEntry in
           let mult = range + 1
           let val1 = Double(arc4random_uniform(mult) + mult / 3)
           let val2 = Double(arc4random_uniform(mult) + mult / 3)
           let val3 = Double(arc4random_uniform(mult) + mult / 3)
           
           return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3])
       }
       
       let set = BarChartDataSet(entries: yVals, label: "Prospect View")
       set.drawIconsEnabled = false
       set.colors = [ChartColorTemplates.material()[0], ChartColorTemplates.material()[1], ChartColorTemplates.material()[2]]
        set.stackLabels = viewModel.yAxisLabels()
       
       let data = BarChartData(dataSet: set)
       data.setValueFont(.systemFont(ofSize: 7, weight: .light))
       data.setValueTextColor(.white)
        
        let months = ["USBank", "Llyods", "Lufthansa", "Tacobell", "Macdonalds", "CitiBank"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        chartView.xAxis.labelPosition = .bottom
       chartView.fitBars = true
       chartView.data = data
    }
}
