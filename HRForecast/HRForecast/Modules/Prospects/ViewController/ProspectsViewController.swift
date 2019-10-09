//
//  ProspectsViewController.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import Charts

class ProspectsViewController: BaseViewController, UIBroker {
    
    var payLoad: [String : Any]?

    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = DashboardConstants.title
    }
    
}
