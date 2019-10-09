//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

open class RequestSerializerJson: RequestSerializer {
    open func serialize(_ object: Any) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
        } catch let error as NSError {
            print("error serializing JsON string: \(error.localizedDescription)")
            return nil
        }
    }
}
