//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

open class BaseService: Service {
    
    enum Headers: String {
        case cacheControl = "Cache-Control"
        
        func toValue() -> String {
            switch self {
            case .cacheControl:
                return "no-cache"
            }
        }
    }

    public static var baseUrl: String?
    
    public var requestType: RequestType = .GET
    public var contentType: ContentType = .FORM
    public var acceptType: AcceptType = .JSON
    public var timeout: TimeInterval = 30
    public var requestURL: String = ""

    public var requestParams: [String: AnyObject]?
    public var additionalHeaders: [String: String]?

    public var customContentType: String?
    public var customAcceptType: String?
    public var requestSerializer: RequestSerializer?
    public var responseParser: ResponseParser?
    public var credential: URLCredential?
    
    public init() {
        self.requestURL = BaseService.baseUrl ?? ""
    }
}
