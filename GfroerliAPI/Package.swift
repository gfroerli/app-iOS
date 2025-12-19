// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GfroerliAPI",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        // The main library
        .library(
            name: "GfroerliAPI",
            targets: ["GfroerliAPI"]
        ),
        // Containing the protocols provided by this package
        .library(
            name: "GfroerliAPIProtocols",
            targets: ["GfroerliAPIProtocols"]
        ),
        // Containing mocks that can be imported by other packages test targets
        .library(
            name: "GfroerliAPIMocks",
            targets: ["GfroerliAPIMocks"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GfroerliAPIProtocols"
        ),
        .target(
            name: "GfroerliAPI",
            dependencies: [
                "GfroerliAPIProtocols",
            ]
        ),
        .target(
            name: "GfroerliAPIMocks",
            dependencies: [
                "GfroerliAPIProtocols",
            ],
            path: "Tests/GfroerliAPIMocks"
        ),
        .testTarget(
            name: "GfroerliAPITests",
            dependencies: [
                "GfroerliAPI",
                "GfroerliAPIMocks",
            ]
        ),
    ]
)
