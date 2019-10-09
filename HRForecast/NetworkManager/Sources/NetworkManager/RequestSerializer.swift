//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

public protocol RequestSerializer {
    func serialize(_ object: Any) -> Data?
}
