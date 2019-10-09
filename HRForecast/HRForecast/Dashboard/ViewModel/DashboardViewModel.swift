//
//  DashboardViewModel.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import Charts

typealias DataFetchCallback = (_ error: NSError?) -> Void

class DashboardViewModel: NSObject {
    
    var fulfillment: ChartData?
    
    override init() {
        super.init()
    }
    
    func getDashboardData(callback:@escaping DataFetchCallback) {
        DashboardWorker.getDashboardData {[weak self] (error, data) in
            self?.fulfillment = data as? ChartData
            callback(nil)
        }
    }
}

extension DashboardViewModel {
    
    func xAxisTitle() -> String {
        return fulfillment?.x.title ?? ""
    }
    
    func xAxis() -> [ChartDataEntry]? {
        return chartDataEntry(fulfillment?.x) as? [ChartDataEntry]
    }
    
    func yAxisTitle() -> String {
        return fulfillment?.y.title ?? ""
    }
    
    func yAxis() -> [String]? {
        return chartDataEntry(fulfillment?.y) as? [String]
    }
    
    func chartDataEntry(_ axis: AxisData?) -> [Any]? {
        guard let axis = axis else {
            return nil
        }
        return axis.values
    }
}
