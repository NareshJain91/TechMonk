//
//  AccountViewController.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import Charts

class AccountViewController: BaseViewController, UIBroker {
    
    var payLoad: [String : Any]?

    @IBOutlet weak var lineChartView: LineChartView!
    
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
    }
    
    func updateChartData() {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [50.0, 25.0, 50.0, 75.0, 100.0, 75.0]

        self.setChart(dataPoints: months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        chartDataSet.circleRadius = 5
        chartDataSet.circleHoleRadius = 2
        chartDataSet.drawValuesEnabled = false

        let chartData = LineChartData(dataSets: [chartDataSet])


        lineChartView.data = chartData

        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true

        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false

        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.legend.enabled = false
    }
}
