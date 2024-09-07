import Foundation

// MARK: - Weather Request Struct

struct WeatherRequest: NetworkRequest {
    let city: String
    var path: String { Components.path }
    var parameters: [(String, Any)] {
        [
            (Components.query, city),
            (Components.appId, Components.apiKey),
            (Components.units, Components.metric)
        ]
    }
}
