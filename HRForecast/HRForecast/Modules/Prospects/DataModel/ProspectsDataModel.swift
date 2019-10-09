//
//  DashboardDataModel.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation

struct SkillSet: Codable {
    var account: String
    var date: String
    var level: String
    var priority: String
    var tenatative_date: String
    var tentative_fulfilment: String
}

struct SkillSetList: Codable {
    var name: String
    var list: [SkillSet]
}

struct Prospects: Codable {
    var list: [SkillSetList]
}

struct ProspectsData {
    var accounts: [String]
}
