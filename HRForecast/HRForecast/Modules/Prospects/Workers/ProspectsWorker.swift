//
//  DashboardWorker.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import Charts
import NetworkManager

class ProspectsWorker: BaseWorker {
    
    static var data = [Any]()
    
    class func getProspects(callback: @escaping WorkerCallback) {
        NetworkManager.sharedInstance().start(ProspectsService(), serviceResponse: { (err: NSError?, result: Any?) -> Void in
            
            guard let response =  result as? Dictionary<String, Any> else {
                let parseError = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Response was not 'Skill Set' object."])
                callback(parseError, nil)
                return
            }
            
            let prospectData = rootKeyForSkillSet(response)
            print(prospectData)
            
            let accountNames = prospectData.list.map {
                $0.name
            }
            
            let prospects = ProspectsData.init(accounts: accountNames)
            prospectsAggregator(prospects, nil, callback: callback)
        })
        
        NetworkManager.sharedInstance().start(CandidatesService(), serviceResponse: { (err: NSError?, result: Any?) -> Void in
            
            guard let response =  result as? Array<Any> else {
                let parseError = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Response was not 'Skill Set' object."])
                callback(parseError, nil)
                return
            }
            
            let candidates = rootKeyForCandidates(response)
            prospectsAggregator(nil, candidates, callback: callback)
        })
    }
    
    class func rootKeyForCandidates(_ data: Array<Any>) -> Candidates {
        var candidatesList = [CandidateInfo]()
        for element in data {
            if let elementData = element as? Dictionary<String, Any> {
                if let candidate = parseData(elementData, type: CandidateInfo.self) {
                    candidatesList.append(candidate)
                }
            }
        }
        let candidates = Candidates(list: candidatesList)
        return candidates
    }
    
    class func rootKeyForSkillSet(_ data: Dictionary<String, Any>) -> Prospects {
        var skillSetList = [SkillSetList]()
        for key in data.keys {
            let value = data[key]
            if value is Array<Any> {
                let skillset = skillSetKey(value as! Array<Any>, name: key)
                skillSetList.append(skillset)
            }
        }
        let accountInfo = Prospects(list: skillSetList)
        return accountInfo
    }
    
    class func skillSetKey(_ data: Array<Any>, name: String) -> SkillSetList {
        var skillsList = [SkillSet]()
        for element in data {
            if let elementData = element as? Dictionary<String, Any> {
                if let skills = parseData(elementData, type: SkillSet.self) {
                    skillsList.append(skills)
                }
            }
        }
        
        return SkillSetList(name: name, list: skillsList)
    }
    
    private class func prospectsAggregator(_ skills: ProspectsData?, _ candidates: Candidates?,
                                           callback: @escaping WorkerCallback) {
        if let skills = skills {
            ProspectsWorker.data.append(skills)
        }
        if let candidates = candidates {
            ProspectsWorker.data.append(candidates)
        }
        
        if data.count >= 2 {
            callback(nil, ProspectsWorker.data)
        }
    }
}
