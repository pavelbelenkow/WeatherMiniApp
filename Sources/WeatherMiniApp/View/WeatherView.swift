import UIKit

final class WeatherView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.textFieldPlaceholder
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 19)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityTextField, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let viewModel: any WeatherViewModelProtocol
    
    // MARK: - Initializers
    
    init(viewModel: any WeatherViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupAppearance()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Static Methods
    
    static func create() -> WeatherView {
        let service = WeatherService()
        let viewModel = WeatherViewModel(weatherService: service)
        return WeatherView(viewModel: viewModel)
    }
}

// MARK: - Private Methods

private extension WeatherView {
    
    func setupAppearance() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func bindViewModel() {
        viewModel.currentTemperatureSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] temperature in
                guard let self else { return }
                temperatureLabel.text = "In \(cityTextField.text ?? "City") temperature is \(Int(temperature))°C"
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.errorMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                temperatureLabel.text = "Couldn't find the weather in your city. \(message)"
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Methods

extension WeatherView {
    
    func configure(
        with backgroundColor: UIColor,
        textColor: UIColor,
        textFont: UIFont
    ) {
        self.backgroundColor = backgroundColor
        temperatureLabel.textColor = textColor
        temperatureLabel.font = textFont
    }
}

// MARK: - UITextFieldDelegate Methods

extension WeatherView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let city = textField.text,
            !city.isEmpty
        else { return }
        
        viewModel.getWeather(for: city)
    }
}
