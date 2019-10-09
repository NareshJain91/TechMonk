//
//  DashboardViewController.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: BaseViewController, UIBroker {
    var payLoad: [String : Any]?
    
    lazy var viewModel = DashboardViewModel()

    @IBOutlet weak var fulfillmentView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setChartData()
    }
}

extension DashboardViewController {
    
    fileprivate func setChartData() {
        fulfillmentView.xAxis.labelPosition = .bottom
        fulfillmentView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        viewModel.getDashboardData { [weak self] error in
            let chartDataSet = BarChartDataSet.init(entries: self?.viewModel.xAxis(), label: self?.viewModel.xAxisTitle())
            chartDataSet.colors = ChartColorTemplates.colorful()
            
            let chartData = BarChartData.init(dataSet: chartDataSet)
            if let yAxis = self?.viewModel.yAxis() {
                let chartFormatter = BarChartFormatter(labels: yAxis)
                self?.fulfillmentView.xAxis.valueFormatter = chartFormatter
                self?.fulfillmentView.xAxis.labelCount = yAxis.count
            }
            self?.fulfillmentView.data = chartData
        }
    }

    // MARK: - IBAction Methods
    @IBAction func buttonAction(_ sender: UIButton) {
//        dashboardViewModel.logIn("VJY333", "scanta") {  [weak self]  (error, response) in
//            guard self != nil else { return }
//            if error {
//                print("Error")
//            } else if let loginModel = response as? DashboardViewModel {
//                print(loginModel.self)
//            }
//        }
    }
}

extension DashboardViewController {

    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
}

