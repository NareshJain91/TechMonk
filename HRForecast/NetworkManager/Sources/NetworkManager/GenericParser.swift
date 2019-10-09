//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

open class GenericParser<T: Decodable> : ResponseParser {
    
    public init() {
    }
    
    public func parse(_ data: Data) -> Any? {
        do {
            let recipient = try data.decode() as T
            return recipient
        } catch let error {
            print("Parser Error " + error.localizedDescription)
            return error
        }
    }
    
    public func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print("Error in Serializing JSON: \(myJSONError)")
        }
        return nil
    }
}
