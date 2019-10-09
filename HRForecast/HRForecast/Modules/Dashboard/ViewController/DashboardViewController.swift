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

    lazy var dashboardViewModel = DashboardViewModel()

    @IBOutlet weak var barChartView: BarChartView! {
        didSet {
            barChartView.noDataText = "You need to provide data for the chart."
            barChartView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        
        title = DashboardConstants.title
        self.hideBackButton()
        self.setNavigationBarColor(Theme.primaryColor, textColor: Theme.primaryTextColor)
        self.setNavigationBarHidden(animaed: false, false)
        
        showActivityIndicator()
        dashboardViewModel.getDashboardData {[weak self] (error) in
            self?.hideActivityIndicator()
            guard error == nil else {
                return
            }
            self?.setUpGroupBar()
        }
    }
    
    @IBAction func prospectsButtonClicked(_ sender: Any) {
        navigate(module: "prospects", pushOrPresent: .push, payLoad: [:],
                 pushPresentAnimated: false, schema: "Dashboard", completion: nil)
    }
}

extension DashboardViewController: ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    /// Called when a user stops panning between values on the chart
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        
    }
    
    // Called when nothing has been selected or an "un-select" has been made.
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    // Callbacks when the chart is scaled / zoomed via pinch zoom gesture.
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    // Callbacks when the chart is moved / translated via drag gesture.
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }

    // Callbacks when Animator stops animating
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        
    }
}

extension DashboardViewController {
    
    private func setUpGroupBar() {
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;

        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.dashboardViewModel.getAccounts())
        xaxis.granularity = 1

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        barChartView.rightAxis.enabled = false
        
        setChart()
    }
    
    private func setChart() {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []

        for i in 0..<self.dashboardViewModel.getAccounts().count {

            let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(self.dashboardViewModel.getOpenNeeds()[i]))
            dataEntries.append(dataEntry)

            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(self.dashboardViewModel.getClosedNeeds()[i]))
            dataEntries1.append(dataEntry1)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Open Needs")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Needs Closed")

        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet1.colors = [UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)]

        let chartData = BarChartData(dataSets: dataSets)

        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        let groupCount = self.dashboardViewModel.getAccounts().count
        let startYear = 0
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.backgroundColor = .clear
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
}
