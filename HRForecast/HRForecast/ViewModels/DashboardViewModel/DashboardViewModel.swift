//
//  DashboardViewModel.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation

typealias DashboardCompletionHandler = (_ isError: Bool, _ loginDetails: DashboardViewModel) -> Void

class DashboardViewModel {
    
    func logIn(_ username: String,_ password: String, _ completionHandler: @escaping DashboardCompletionHandler) {
//        let parameters: [String: Any] = [
//            "username" : username,
//            "pass" : password
//        ]
//        NetworkManager.requestGETURL(Constants.Url.dummyAPI, success: { (response) in
//            let result = response["status"].boolValue
//            print(response)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        NetworkManager.requestFromLocalJson("dummy", success: { (response) in
            print(response)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
//        NetworkManager.requestPOSTURL(Constants.Url.loginAPI, params: parameters, success: { (response) in
//            let result = response["status"].boolValue
//            print(response)
//            if result {
//                print("Pass")
//            } else {
//                print("Fail")
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
}
