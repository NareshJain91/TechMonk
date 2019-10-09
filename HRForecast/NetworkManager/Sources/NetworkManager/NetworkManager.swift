
public protocol NetworkClientProtocol {
    // @available(*, deprecated)
    /// Usage of this should be replaced with alternative found `startService()`
    func start(_ service: Service, serviceResponse: @escaping ServiceResponse)
}

extension NetworkClientProtocol {
    func start(_ service: Service, serviceResponse: @escaping ServiceResponse) {
        start(service, serviceResponse: serviceResponse)
    }
}

open class NetworkManager {
    
    private static var instance: NetworkClientProtocol?
    
    public class func setInstance(_ instance: NetworkClientProtocol) {
        NetworkManager.instance = instance
    }

    public static func sharedInstance() -> NetworkClientProtocol {
        guard let instance = NetworkManager.instance else {
            let instance = ApiNetworkClient()
            NetworkManager.instance = instance
            return instance
        }
        
        return instance
    }
}
