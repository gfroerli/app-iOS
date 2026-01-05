// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GfroerliBusiness",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        // The main library
        .library(
            name: "GfroerliBusiness",
            targets: ["GfroerliBusiness"]
        ),
        // Containing the protocols provided by this package
        .library(
            name: "GfroerliBusinessProtocols",
            targets: ["GfroerliBusinessProtocols"]
        ),
        // Containing mocks that can be imported by other packages test targets
        .library(
            name: "GfroerliBusinessMocks",
            targets: ["GfroerliBusinessMocks"]
        ),
    ],
    dependencies: [
        .package(path: "../GfroerliAPI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GfroerliBusinessProtocols"
        ),
        .target(
            name: "GfroerliBusiness",
            dependencies: [
                "GfroerliBusinessProtocols",
                "GfroerliAPI",
            ]
        ),
        .target(
            name: "GfroerliBusinessMocks",
            dependencies: [
                "GfroerliBusinessProtocols",
            ],
            path: "Tests/GfroerliBusinessMocks"
        ),
        .testTarget(
            name: "GfroerliBusinessTests",
            dependencies: [
                "GfroerliBusiness",
                "GfroerliBusinessProtocols",
                "GfroerliBusinessMocks",
            ]
        ),
    ]
)
