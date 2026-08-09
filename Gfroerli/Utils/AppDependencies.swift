//
//  AppDependencies.swift
//  Gfroerli
//

import Foundation
import GfroerliBusiness
import GfroerliBusinessMocks
import GfroerliBusinessProtocols

enum AppDependencies {

    /// The launch argument the UI test passes to request screenshot mode.
    static let screenshotLaunchArgument = "-uiScreenshots"

    static let isScreenshotMode = ProcessInfo.processInfo.arguments.contains(screenshotLaunchArgument)

    // MARK: - Factories

    static func makeAllLocationsManager() -> BusinessAllLocationsManagerProtocol {
        isScreenshotMode ? BusinessAllLocationsManagerMock() : BusinessAllLocationsManager()
    }

    static func makeLocationManager() -> BusinessLocationManagerProtocol {
        isScreenshotMode ? BusinessLocationManagerMock() : BusinessLocationManager()
    }

    static func makeSponsorManager() -> BusinessSponsorManagerProtocol {
        isScreenshotMode ? BusinessSponsorManagerMock() : BusinessSponsorManager()
    }

    static func makeMeasurementManager() -> BusinessMeasurementManagerProtocol {
        isScreenshotMode ? BusinessMeasurementManagerMock() : BusinessMeasurementManager()
    }

    static func makeUserLocationProvider() -> UserLocationProviding {
        isScreenshotMode ? EmptyUserLocationProvider() : LiveUserLocationProvider()
    }

    // MARK: - Launch

    /// Wires up launch-time state. Call once from the app entry point.
    @MainActor
    static func bootstrap() {
        // Seed deterministic favorites when capturing screenshots.
        if isScreenshotMode {
            UserDefaults.standard.set(
                BusinessLocationMock.screenshotFavoriteIDs.rawValue,
                forKey: "favorites"
            )
        }
    }
}
