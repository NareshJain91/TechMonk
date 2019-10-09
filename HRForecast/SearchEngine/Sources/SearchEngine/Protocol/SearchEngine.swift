//
//  SearchEngine.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

typealias SearchResultsHandler = () -> Array<Profile>

protocol SearchEngine {
    func profiles(skill: String, experience: Int, minSalary: Double, maxSalary: Double,
                  responseHandler: SearchResultsHandler) -> Array<Profile>
}

class SearchEngineManager {
    var handler: SearchEngine?
    static var shared = SearchEngineManager()
    
    private init() {
        // To make the instance private
    }
    
    class func getProfiles(skill: String, experience: Int,
                           responseHandler: SearchResultsHandler) -> Array<Profile> {
        return SearchEngineManager.getProfiles(skill: skill, experience: experience,
                                               minSalary: 0.0, maxSalary: 0.0,
                                               responseHandler: responseHandler)
    }
    
    class func getProfiles(skill: String, experience: Int,
                           minSalary: Double, maxSalary: Double,
                           responseHandler: SearchResultsHandler) -> Array<Profile> {
        return SearchEngineManager.shared.handler?.profiles(skill: skill, experience: experience,
                                                            minSalary: minSalary, maxSalary: maxSalary,
                                                            responseHandler: responseHandler) ?? [Profile()]
    }
}
