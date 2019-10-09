//
//  DashboardWorker.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import Charts

typealias WorkerCallback = (_ error: NSError?, _ data: Any?) -> Void

fileprivate let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
let MAXCHARTLINES = 6
let TOTALMONTHS = 12

class DashboardWorker {
    
    class func getDashboardData(callback: @escaping WorkerCallback) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
            var dataEntries: [BarChartDataEntry] = []
            
            var maxChartValues = TOTALMONTHS - Calendar.current.component(.month, from: Date())
            if maxChartValues < MAXCHARTLINES {
                maxChartValues = MAXCHARTLINES
            }
                    
            for i in 0...maxChartValues-1 {
                let dataEntry = BarChartDataEntry.init(x: Double.init(i), y: values[maxChartValues+i-1])
                dataEntries.append(dataEntry)
            }
            
            let x = AxisData.init(title: "Fullfilled", values: dataEntries)
            let y = AxisData.init(title: "", values: Array(months.suffix(from: maxChartValues)))
            let data = ChartData(x: x, y: y)
            callback(nil, data)
        }
        
//        NetworkManager.sharedInstance().callService(DepositHistoryService(), errorHandler: DepositHistoryErrorHandler(), withCallback: { (error, responseObject) in
//            callback(error, responseObject.response)
//        })
    }
}
