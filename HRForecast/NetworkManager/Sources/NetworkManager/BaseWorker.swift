//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 10/10/19.
//

import Foundation

open class BaseWorker {
    
    public class func parseData<T: Decodable>(_ data: Dictionary<String, Any>, type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let skillSet = try jsonDecoder.decode(type, from: jsonData) as T
            return skillSet
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
