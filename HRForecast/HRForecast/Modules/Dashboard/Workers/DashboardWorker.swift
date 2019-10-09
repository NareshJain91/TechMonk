//
//  DashboardWorker.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import Charts
import NetworkManager

typealias WorkerCallback = (_ error: NSError?, _ data: Any?) -> Void

class DashboardWorker {
    
    class func getDashboardData(callback: @escaping WorkerCallback) {
        let serviceResponse: ServiceResponse = { (err: NSError?, result: Any?) -> Void in
            guard let response =  result as? Dictionary<String, Any> else {
                let parseError = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Response was not 'BankHolidays' object."])
                callback(parseError, nil)
                return
            }
            
            let dashboardData = rootKey(response, type: SkillSetInfo.self)
            let accountNames = dashboardData.accounts.map {
                $0.name
            }
            
            var requirementFulfilled = [Int]()
            var requirementCount = [Int]()
            for account in dashboardData.accounts {
                var requirements = 0
                var fulfillments = 0
                for skill in account.skillset {
                    requirements += skill.requirementCount
                    fulfillments += skill.requirementFulfilled
                }
                
                requirementFulfilled.append(fulfillments)
                requirementCount.append(requirements)
            }
            
            let chartData = ChartData.init(requirementCount: requirementCount,
                                           requirementFulfilled: requirementFulfilled,
                                           accounts: accountNames)
            callback(nil, chartData)
        }
        
        NetworkManager.sharedInstance().start(DashboardService(),
                                              serviceResponse: serviceResponse)
    }
    
    class func rootKey<T: Decodable>(_ data: Dictionary<String, Any>, type: T.Type) -> DashboardData {
        var accountsList = [AccountInfo]()
        for key in data.keys {
            let value = data[key]
            if value is Array<Any> {
                let accountInfo = accountKey(value as! Array<Any>, accountName: key)
                accountsList.append(accountInfo)
            }
        }
        let accountInfo = DashboardData(accounts: accountsList)
        return accountInfo
    }
    
    class func accountKey(_ data: Array<Any>, accountName: String) -> AccountInfo {
        var skillsList = [SkillSetInfo]()
        for element in data {
            if let elementData = element as? Dictionary<String, Any> {
                if let skills = parseData(elementData, type: SkillSetInfo.self) {
                    skillsList.append(skills)
                }
            }
        }
        
        return AccountInfo(skillset: skillsList, name: accountName)
    }
    
    class func parseData<T: Decodable>(_ data: Dictionary<String, Any>, type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let skillSet = try jsonDecoder.decode(type, from: jsonData) as T
            return skillSet
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
