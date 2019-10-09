//
//  ActivityIndicatorView.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {
    override init(frame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)) {
        super.init(frame: frame)
        self.style = .whiteLarge
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.style = .whiteLarge
    }
}
