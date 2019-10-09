//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

public enum RequestType: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
}

public enum ContentType: String {
    case XML = "application/xml"
    case JSON = "application/json"
    case FORM = "application/x-www-form-urlencoded"
    case NONE = ""
}

public enum AcceptType: String {
    case XML = "application/xml"
    case JSON = "application/json"
    case HTML = "text/html"
    case TEXT = "text/plain"
    case JAVASCRIPT = "text/javascript"
    case NONE = ""
}

public enum TrafficManagement: Int {
    case  allowDuplicates = 0 //default - allows multiple async calls with same URI
    case  restrictDuplicates // restricts multiple async calls with same URI
    case  pushIntimationOnCompletion //  notifies the sender of completion *
    case  waitUntilCompletion // waits until the completion of X-Service, has no effect if "dependentServiceURL" is empty
    case fireAndForget // Provide No call back
}

public enum ServiceCompletionStatus: Int {
    case serviceInProgress = 0
    case serviceCompleted = 1
}

public protocol Service {
    static var baseUrl: String? { get set }
    
    var requestType: RequestType { get }
    var contentType: ContentType { get }
    var acceptType: AcceptType { get }
    var timeout: TimeInterval { get }
    var requestURL: String { get }
    
    var requestParams: [String: AnyObject]? { get }
    var additionalHeaders: [String: String]? { get }
    
    var customContentType: String? { get }
    var customAcceptType: String? { get }
    var requestSerializer: RequestSerializer? { get }
    var responseParser: ResponseParser? { get }
    var credential: URLCredential? { get }
}
