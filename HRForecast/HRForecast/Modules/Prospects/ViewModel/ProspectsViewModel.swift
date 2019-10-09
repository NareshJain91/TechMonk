//
//  DashboardViewModel.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import Charts

class ProspectsViewModel: NSObject {
    
    var fulfillment: ChartData?
    
    override init() {
        super.init()
    }
    
    func getProspects(callback:@escaping DataFetchCallback) {
        ProspectsWorker.getProspects() {[weak self] (error, data) in
            self?.fulfillment = data as? ChartData
            callback(nil)
        }
    }
}
