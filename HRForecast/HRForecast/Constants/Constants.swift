//
//  Constants.swift
//  Tint
//
//  Created by Naresh Jain on 27/05/19.
//  Copyright © 2019 Scanta. All rights reserved.
//

import Foundation

struct Constants {

    static let baseURL = "http://34.212.28.121"
    static let hostPath = "/sass/webapi"
    
    /// Constants for MCD Network Path
    struct Url {
        static let loginAPI = baseURL + hostPath + "/user/login"
        static let dummyAPI = "https://jsonplaceholder.typicode.com/todos/1"
    }
}

