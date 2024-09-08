import UIKit
import MiniAppCore

public final class WeatherMiniApp: MiniAppProtocol {
    
    // MARK: - Public Properties
    
    public var title: String = Const.miniAppTitle
    
    public var icon: UIImage = UIImage(systemName: Const.miniAppIcon) ?? UIImage()
    
    public private(set) var view: UIView = WeatherView.create()
    
    // MARK: - Public Initializers
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func configure(with configuration: MiniAppConfiguration) {
        if let weatherView = view as? WeatherView {
            weatherView.configure(
                with: configuration.backgroundColor,
                textColor: configuration.textColor,
                textFont: configuration.font
            )
        }
    }
}
