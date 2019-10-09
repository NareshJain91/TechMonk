//
//  DashboardDataModel.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation

struct ChartPointData {
    var value = 0.0
    var index = 0
}

struct AxisData {
    var title: String
    var values: Array<Any>
}

struct ChartData {
    var x: AxisData
    var y: AxisData
}
