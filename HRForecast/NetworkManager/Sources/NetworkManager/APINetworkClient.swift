//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//
import Foundation

//https://bugs.swift.org/browse/SR-2522
typealias goalStackCompletion = (service: Service, iserrorGlobally: Bool, serviceResponse: ServiceResponse)

/// Provides a bridge between lower-level SesssionManger and handling of errors
/// at a client / UI level
class ApiNetworkClient: NetworkClientProtocol {
    var serviceLoggerDict = [String: ServiceCompletionStatus]()

    // TODO: Candidate to move to ServiceManager
    //Handles the invocation of waiting services after completion
    var goalStack = [String: goalStackCompletion]()

    /// Initate a network request
    ///
    /// - Parameters:
    ///   - service: Service the callee wishes to call
    ///   - iserrorGlobally: if set `true` then 400, 500 and 404 errors are handled automatically
    ///   - serviceResponse: response callback when service call returns or times out
    func start(_ service: Service, serviceResponse: @escaping ServiceResponse) {

        // Service initiation and response handler
        SessionManager.sharedInstance().start(service) { [weak self](err, result) in
            // no error, return response assuming success
            if result != nil {
                serviceResponse(err, result)
                return
            }

            // if we have an error code not matching 200, we have a confirmed error, handle below
            // otherwise return with the result
            // TODO: should we limit to only 200???
            guard let errorSafe = err, errorSafe.code != 200 else {
                serviceResponse(err, result)
                return
            }

            // ---------------------------------------------------------
            // From here -- we assume there is an error
            // ---------------------------------------------------------

            // ---------------------------------------------------------
            // ERROR handling begins here
            // ---------------------------------------------------------

            // If we are unable to parse the error object, return back the "response with error" and let the service handle it
            guard let data = errorSafe.userInfo["Response"] as? Data else {
                serviceResponse(err, result)
                return
            }

            serviceResponse(errorSafe, result)
            // ---------------------------------------------------------
            // End of error processing
            // ---------------------------------------------------------
        }
    }
}
