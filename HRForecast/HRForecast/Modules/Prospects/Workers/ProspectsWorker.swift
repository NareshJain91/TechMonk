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

class ProspectsWorker {
    
    static var data = [Any]()
    
    class func getProspects(callback: @escaping WorkerCallback) {
//        NetworkManager.requestGETURL(ProspectsConstants.Url.skillSetsAPI, success: { (response) in
//            prospectsAggregator(response, nil, callback: callback)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        NetworkManager.requestGETURL(ProspectsConstants.Url.candidatesAPI, success: { (response) in
//            prospectsAggregator(nil, response, callback: callback)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    private class func prospectsAggregator(_ skills: Array<SkillSet>?, _ candidates: Array<Candidates>?,
                                           callback: @escaping WorkerCallback) {
        if let skills = skills {
            ProspectsWorker.data.append(skills)
        }
        if let candidates = candidates {
            ProspectsWorker.data.append(candidates)
        }
        
        if data.count > 2 {
            callback(nil, nil)
        }
    }
}
