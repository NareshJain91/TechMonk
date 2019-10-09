//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

public typealias ServiceResponse = (NSError?, Any?) -> Void
public typealias ServiceResponseObject = (NSError?, ResponseObject) -> Void

public struct ResponseObject {
    public var statusCode: Int
    public var headers: [String: Any]
    public var response: Any?
    public init(statusCode: Int, headers: [String: Any], response: Any?) {
        self.statusCode = statusCode
        self.headers = headers
        self.response = response
    }
}

open class SessionManager: NSObject {
    fileprivate static var instance: SessionManager?
    
    public static var errorDomain = "errordomain"
    public static var trustKitConfig: [String: Any]?
    public static var allowInvalidCertificates: Bool = false
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Service Queue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    fileprivate var session: Foundation.URLSession!
    fileprivate var credential: URLCredential?
    
    override init() {
        super.init()
        createSession()
    }
    
    // MARK: SHARED INSTANCE
    
    open class func sharedInstance() -> SessionManager {
        guard let sessionManager = SessionManager.instance else {
            SessionManager.instance = SessionManager()
            return SessionManager.instance!
        }
        
        return sessionManager
    }
    
    // MARK: SETUP METHODS
    
    fileprivate func createSession() {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: queue)
    }
    
    // MARK: PUBLIC METHODS
    
    open func resetSession() {
        session = nil
        credential = nil
        createSession()
    }
    
    open func start(_ service: Service, serviceResponse:@escaping ServiceResponse) {
        startService(service) { (error, responseObject) in
            serviceResponse(error, responseObject.response)
        }
    }
    
    open func startService(_ service: Service, withResponseObject serviceResponse: @escaping ServiceResponseObject) {
        if let serviceCredential = service.credential {
            credential = serviceCredential
        }
        
        var responseObject = ResponseObject(statusCode: -1, headers: [:], response: nil)
        
        let request = createRequest(service)
        session.dataTask(with: request, completionHandler: { [unowned self] (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let err = error as NSError? {
                    serviceResponse(err, responseObject)
                } else {
                    if let urlResponse = response as? HTTPURLResponse {
                        if let headers = urlResponse.allHeaderFields as? [String: AnyObject] {
                            responseObject.headers = headers
                            if let contentTypeHeader = headers["Content-Type"] as? String {
                                let contentType = self.getContentType(contentTypeHeader: contentTypeHeader)
                                
                                let acceptType = self.getAcceptType(service: service)
                                
                                if acceptType == contentType {
                                    if let responseData = data {
                                        let statusCode = urlResponse.statusCode
                                        responseObject.statusCode = statusCode
                                       
                                        if statusCode > 299 {
                                            let error = NSError(domain: SessionManager.errorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error - use 'Response' key for response data", "Response": responseData])
                                            serviceResponse(error, responseObject)
                                            
                                            return
                                        }
                                        
                                        /*if let parser = service.responseParser // CUSTOM PARSER
                                        {
                                            if let parsedData = parser.parse(responseData) {
                                                responseObject.response = parsedData
                                                switch parsedData {
                                                case is NSError:
                                                    serviceResponse((parsedData as! NSError), responseObject)
                                                default:
                                                    
                                                    serviceResponse(nil, responseObject)
                                                }
                                            } else {
                                                let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse response.", "Response": responseData])
                                                serviceResponse(error, responseObject)
                                            }
                                        } else // USE DEFAULT PARSERS
                                        { */
                                            switch service.acceptType {
                                            case .JSON:
                                                if let parsedData = ResponseParserJson().parse(responseData) {
                                                    responseObject.response = parsedData
                                                    serviceResponse(nil, responseObject)
                                                } else {
                                                    let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse response.", "Response": responseData])
                                                    serviceResponse(error, responseObject)
                                                }
                                            case .HTML, .TEXT:
                                                if let text = String(data: responseData, encoding: String.Encoding.utf8) {
                                                    responseObject.response = text
                                                    serviceResponse(nil, responseObject)
                                                } else if let text = String(data: responseData, encoding: String.Encoding.ascii) {
                                                    responseObject.response = text
                                                    serviceResponse(nil, responseObject)
                                                } else {
                                                    let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse response.", "Response": responseData])
                                                    serviceResponse(error, responseObject)
                                                }
                                            case .XML:
                                                responseObject.response = XMLParser(data: responseData)
                                                serviceResponse(nil, responseObject)
                                            default:
                                                responseObject.response = responseData
                                                serviceResponse(nil, responseObject)
                                            }
//                                        }
                                    } else {
                                        serviceResponse(nil, responseObject)
                                    }
                                } else {
                                    let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid content type. Expected '\(acceptType)' but received '\(contentType)' from response."])
                                    serviceResponse(error, responseObject)
                                }
                            } else {
                                let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "No content type specified."])
                                serviceResponse(error, responseObject)
                            }
                        }
                    } else {
                        let error = NSError(domain: SessionManager.errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned from server."])
                        serviceResponse(error, responseObject)
                    }
                }
            })
        }).resume()
    }
    
    // MARK: HELPER METHODS
    
    fileprivate func createRequest(_ service: Service) -> URLRequest {
        let request = NSMutableURLRequest()

        // do not cache (store) request responses in cache.db (on disk)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        request.url = URL(string: service.requestURL)
        
        request.httpMethod = service.requestType.rawValue
        
        request.timeoutInterval = service.timeout
        
        if let additionalHeaders = service.additionalHeaders {
            for (key, value) in additionalHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let customContentType = service.customContentType {
            request.setValue(customContentType, forHTTPHeaderField: "Content-Type")
        } else {
            if service.contentType.rawValue != "" {
                request.setValue(service.contentType.rawValue, forHTTPHeaderField: "Content-Type")
            }
        }
        
        if let customAcceptType = service.customAcceptType {
            request.setValue(customAcceptType, forHTTPHeaderField: "Accept")
        } else {
            if service.acceptType.rawValue != "" {
                request.setValue(service.acceptType.rawValue, forHTTPHeaderField: "Accept")
            }
        }
        
        guard let requestParams = service.requestParams else {
            return request as URLRequest
        }
        
        if requestParams.count > 0 {
            if let serializer = service.requestSerializer // IF THE SERVICE HAS A CUSTOM SERIALIZER
            {
                if let data = serializer.serialize(requestParams as Any) {
                    request.httpBody = data
                }
            } else {
                switch service.contentType // USE DEFAULT SERIALIZERS
                {
                case.JSON:
                    if let data = RequestSerializerJson().serialize(requestParams as Any) {
                        request.httpBody = data
                    }
                case.FORM:
                    if let data = RequestSerializerForm().serialize(requestParams as Any) {
                        if service.requestType == .GET {
                            if let vars = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                                request.url = URL(string: service.requestURL+"?"+vars)
                            }
                        } else {
                            request.httpBody = data
                        }
                    }
                case.XML:break // TODO: HANDLE XML BODY
                case.NONE:break
                }
            }
        }
        
        return request as URLRequest
    }
    
    fileprivate func getContentType(contentTypeHeader: String) -> String {
        var contentType = contentTypeHeader
        let contentTypeArray = contentTypeHeader.components(separatedBy: ";")
        if contentTypeArray.count > 0 {
            contentType = contentTypeArray[0]
        }
        
        return contentType
    }
    
    fileprivate func getAcceptType(service: Service) -> String {
        var acceptType = service.acceptType.rawValue
        if let customAcceptType = service.customAcceptType {
            acceptType = customAcceptType
        }
        
        return acceptType
    }
}

// MARK: SESSION TASK DELEGATE
//extension SessionManager: URLSessionTaskDelegate {
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if challenge.previousFailureCount == 0 {
//            let authMethod = challenge.protectionSpace.authenticationMethod
//            print("authentication method: \(authMethod)")
//            switch authMethod {
//            case NSURLAuthenticationMethodClientCertificate:completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, credential)
//            case NSURLAuthenticationMethodServerTrust:
//                
//                if SessionManager.trustKitConfig != nil {
//                    
//                } else {
//                    if SessionManager.allowInvalidCertificates {
//                        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//                    } else {
//                        completionHandler(Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
//                    }
//                }
//            default:completionHandler(Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
//            }
//        } else {
//            completionHandler(Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
//        }
//    }
//}

