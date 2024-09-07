import Foundation

// MARK: - Constants

enum Components {
    static let baseEndpoint = "https://api.openweathermap.org"
    static let path = "/data/2.5/weather"
    static let query = "q"
    static let appId = "appid"
    static let apiKey = "b728fa61e140ca3eb37b07b20ef4e361"
    static let units = "units"
    static let metric = "metric"
}

enum Const {
    static let miniAppTitle = "Current Weather"
    static let miniAppIcon = "cloud.sun"
    static let textFieldPlaceholder = "Enter city"
}
