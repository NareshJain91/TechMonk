//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

open class ResponseParserJson: ResponseParser {
    open func parse(_ data: Data) -> Any? {
        do {
            let responseBody = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return responseBody as Any?
        } catch let error as NSError {
            print("error parsing data: \(error.localizedDescription)")
            return nil
        }
    }
}
