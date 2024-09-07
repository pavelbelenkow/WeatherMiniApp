// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherMiniApp",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherMiniApp",
            targets: ["WeatherMiniApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pavelbelenkow/MiniAppCore", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeatherMiniApp",
            dependencies: ["MiniAppCore"]
        ),
        .testTarget(
            name: "WeatherMiniAppTests",
            dependencies: ["WeatherMiniApp"]),
    ]
)
