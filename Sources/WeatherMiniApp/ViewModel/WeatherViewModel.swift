import Combine

// MARK: - Protocols

protocol WeatherViewModelProtocol: ObservableObject {
    var currentTemperatureSubject: PassthroughSubject<Double, Never> { get }
    var errorMessageSubject: PassthroughSubject<String, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    
    func getWeather(for city: String)
}

final class WeatherViewModel: WeatherViewModelProtocol {
    
    // MARK: - Subject Properties
    
    private(set) var currentTemperatureSubject: PassthroughSubject<Double, Never> = .init()
    private(set) var errorMessageSubject: PassthroughSubject<String, Never> = .init()
    
    // MARK: - Private Properties
    
    private let weatherService: WeatherServiceProtocol
    
    // MARK: - Properties
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    // MARK: - Deinitializers
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Methods

extension WeatherViewModel {
    
    func getWeather(for city: String) {
        weatherService
            .fetchWeather(for: city)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let failure) = completion {
                        self?.errorMessageSubject.send(failure.localizedDescription)
                    }
                },
                receiveValue: { [weak self] weather in
                    self?.currentTemperatureSubject.send(weather.main.temp)
                }
            )
            .store(in: &cancellables)
    }
}
