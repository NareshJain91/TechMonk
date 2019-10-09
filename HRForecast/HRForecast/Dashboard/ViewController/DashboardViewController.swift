//
//  DashboardViewController.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {
    
    lazy var dashboardViewModel = DashboardViewModel()

    @IBOutlet weak var fulfillmentView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

