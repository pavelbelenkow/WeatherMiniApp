import Foundation

// MARK: - NetworkRequest Protocol

protocol NetworkRequest {
    var baseEndpoint: String { get }
    var path: String { get }
    var parameters: [(String, Any)] { get }
    var httpMethod: HttpMethod { get }
    
    func asURLRequest() -> URLRequest?
}

// MARK: - Default Request Values

extension NetworkRequest {
    var baseEndpoint: String { Components.baseEndpoint }
    var httpMethod: HttpMethod { .get }
    
    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: baseEndpoint + path)
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.0, value: String(describing: $0.1))
        }
        
        guard let url = components?.url else {
            assertionFailure("Invalid URL")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        return urlRequest
    }
}
