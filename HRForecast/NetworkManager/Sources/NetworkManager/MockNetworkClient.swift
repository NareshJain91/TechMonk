//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

enum MockNetworkResponseCode: Int {
    case none
    case success = 200
    case infraDown = 500
    case requestIncorrect = 400
}

class MockNetworkClient: NetworkClientProtocol {

    private var strMockJSONFile: String?
    private var mockNetworkResponseCode = MockNetworkResponseCode.success

    func start(_ service: Service, iserrorGlobally: Bool, serviceResponse: @escaping ServiceResponse) {
        var jsonFileName = ""

        // atttempt to get result from service + service URL
        jsonFileName = self.lookupJsonFromService(service: service)
        if jsonFileName == "" {
            return
        }

        // this was added recently -- you can specifically set the value on the class property
        // which will override the lookup by service (above)
        if let alternatePath = strMockJSONFile {
            jsonFileName = alternatePath
        }

        // Load JSON from resource file
        guard let jsonData = loadDataFromJsonFile(fileName: jsonFileName) else {
            return
        }

        //----
        // prepare response for service from loaded data and return
        let parseData = service.responseParser?.parse(jsonData)
        if mockNetworkResponseCode != .success {
            var userInfo: [String: Any] = [:]
            if let sendParseData = parseData {
                userInfo = ["Response": sendParseData]
            }
            let error = NSError.init(domain: SessionManager.errorDomain,
                                     code: mockNetworkResponseCode.rawValue,
                                     userInfo: userInfo)
            serviceResponse(error, nil)
        } else {
            serviceResponse(nil, parseData)
        }

        strMockJSONFile = nil
        mockNetworkResponseCode = MockNetworkResponseCode.success
    }
    
    // determines what mock JSON to load from service type or service request URL
    private func lookupJsonFromService(service: Service) -> String {
        var jsonFileName: String = ""

        return jsonFileName
    }

    // load Json from file
    private func loadDataFromJsonFile(fileName: String) -> Data? {
        //Mock data
        let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        let data = try? Data.init(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }

    func setMockSourceExplicitly(_ strMockJSONFile: String, responseCode: MockNetworkResponseCode) {
        self.strMockJSONFile = strMockJSONFile
        self.mockNetworkResponseCode = responseCode
    }
}
