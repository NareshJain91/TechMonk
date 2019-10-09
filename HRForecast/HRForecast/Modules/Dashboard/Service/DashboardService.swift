//
//  DashboardService.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import NetworkManager

class DashboardService: BaseService {

    override init() {
        super.init()

        if let baseURL = BaseService.baseUrl {
            requestURL = baseURL + DashboardConstants.Url.accountsAPI
        }

        self.requestType = .GET
        self.acceptType = .JSON
        self.contentType = .JSON

        self.requestParams = [String: AnyObject]()
        
        self.responseParser =  GenericParser<DashboardData>()
    }
}
