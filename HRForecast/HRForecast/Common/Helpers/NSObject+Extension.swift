//
//  NSObject+Extension.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation

extension NSObject {

    var className: String {
        return self.classForCoder.description()
    }

    class var className: String {
        return self.classForCoder().description()
    }

    var onlyClassName: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }

    class var onlyClassName: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
}
