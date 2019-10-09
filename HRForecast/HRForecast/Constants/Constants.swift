//
//  Constants.swift
//  Tint
//
//  Created by Naresh Jain on 27/05/19.
//  Copyright © 2019 Scanta. All rights reserved.
//

import Foundation

struct Constants {

    static let baseURL = "https://hrforecast-9141e.firebaseio.com"
    
    struct Url {
        static let accountsAPI = baseURL + "/accounts.json"
        static let skillSetAPI = baseURL + "/skillSet.json"
        static let profileAPI = baseURL + "/profiles.json"
        static let candidateAPI = baseURL + "/candidates.json"
    }
}

