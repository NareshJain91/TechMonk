//
//  BaseViewController.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, LoadingIndicatorViewController {
    
    private var orientations = UIInterfaceOrientationMask.landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return orientations
        }
        set {
            orientations = newValue
        }
    }
}
