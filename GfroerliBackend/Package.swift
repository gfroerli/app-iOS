// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GfroerliBackend",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "GfroerliBackend",
            targets: ["GfroerliBackend"]),
    ],
    targets: [
        .target(
            name: "GfroerliBackend"),
        .testTarget(
            name: "GfroerliBackendTests",
            dependencies: ["GfroerliBackend"]),
    ]
)
