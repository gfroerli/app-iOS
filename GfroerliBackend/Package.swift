// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "GfroerliBackend",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(
            name: "GfroerliBackend",
            targets: ["GfroerliBackend"]
        ),
    ],
    targets: [
        .target(
            name: "GfroerliBackend",
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-strict-concurrency=complete",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                    "-Xfrontend", "-warn-long-function-bodies=100",
                    "-Xfrontend", "-warn-long-expression-type-checking=100",
                ]),
            ]
        ),
        .testTarget(
            name: "GfroerliBackendTests",
            dependencies: ["GfroerliBackend"]
        ),
    ],
    swiftLanguageModes: [.version("6")]
)
