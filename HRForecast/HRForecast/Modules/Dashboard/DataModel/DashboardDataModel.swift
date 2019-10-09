//
//  DashboardDataModel.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation

struct ChartData {
    var requirementCount: [Int]
    var requirementFulfilled: [Int]
    var accounts: [String]
}

struct SkillSetInfo: Codable {
    var date: String
    var requirementCount: Int
    var requirementFulfilled: Int
    var tenatative_date: String
    var tentative_fulfilment: String
    var priority: String
    var platform: String
    var level: String
}

struct AccountInfo: Codable {
    var skillset: [SkillSetInfo]
    var name: String
}

struct DashboardData: Codable {
    var accounts: [AccountInfo]
}

