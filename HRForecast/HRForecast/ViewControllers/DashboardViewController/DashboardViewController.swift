//
//  DashboardViewController.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    lazy var dashboardViewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - IBAction Methods
    @IBAction func buttonAction(_ sender: UIButton) {
        dashboardViewModel.logIn("VJY333", "scanta") {  [weak self]  (error, response) in
            guard self != nil else { return }
            if error {
                print("Error")
            } else if let loginModel = response as? DashboardViewModel {
                print(loginModel.self)
            }
        }
    }

}

