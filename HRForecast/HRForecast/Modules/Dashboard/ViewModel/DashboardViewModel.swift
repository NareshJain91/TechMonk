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
    func getAccounts() -> [String] {
        return fulfillment?.accounts ?? []
    }
    
    func getOpenNeeds() -> [Int] {
        return fulfillment?.requirementFulfilled ?? []
    }
    
    func getClosedNeeds() -> [Int] {
        return fulfillment?.requirementCount ?? []
    }
}
