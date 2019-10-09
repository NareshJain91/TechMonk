//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

public protocol ResponseParser {
    func parse(_ data: Data) -> Any?
}
