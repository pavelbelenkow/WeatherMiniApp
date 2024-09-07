import Foundation

// MARK: - Weather Model Struct

struct WeatherModel: Decodable {
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
