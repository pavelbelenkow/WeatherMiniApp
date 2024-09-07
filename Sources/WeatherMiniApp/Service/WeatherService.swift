import Foundation
import Combine

// MARK: - Protocols

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherModel, Error>
}

final class WeatherService {
    
    // MARK: - Private Properties
    
    private let networkClient: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Initializers
    
    init(
        networkClient: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.networkClient = networkClient
        self.decoder = decoder
    }
}

// MARK: - WeatherServiceProtocol Methods

extension WeatherService: WeatherServiceProtocol {
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherModel, Error> {
        let request = WeatherRequest(city: city)
        
        guard let urlRequest = request.asURLRequest() else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return networkClient
            .dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: WeatherModel.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
