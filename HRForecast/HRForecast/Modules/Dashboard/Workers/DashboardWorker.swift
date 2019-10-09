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

class DashboardWorker {
    
    class func getDashboardData(callback: @escaping WorkerCallback) {
        NetworkManager.requestGETURL(Constants.Url.accountsAPI, success: { (response) in
            var accounts: [String] = []
            for (key, _) in response {
                accounts.append(key)
            }
            var openNeeds: [Int] = []
            var closedNeeds: [Int] = []
            
            for (_, value) in response {
                var requirementFulfilled = 0
                var requirementCount = 0
                for item in (value.array ?? nil)! {
                    requirementFulfilled += item["requirementFulfilled"].intValue
                    requirementCount += item["requirementCount"].intValue
                }
                openNeeds.append(requirementCount)
                closedNeeds.append(requirementFulfilled)
            }
            let data = ChartData(requirementCount: openNeeds, requirementFulfilled: closedNeeds, accounts: accounts)
            callback(nil, data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
