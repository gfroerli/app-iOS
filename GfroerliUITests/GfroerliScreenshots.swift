//
//  GfroerliScreenshots.swift
//  GfroerliUITests
//
//  Created by Marc on 26.11.2023.
//

import ScreenshotKit
import UIKit
import XCTest

final class GfroerliScreenshots: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCaptureScreenshots() async throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiScreenshots"]

        // App Store iPad shots are captured in landscape.
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }

        app.launch()

        let processor = ScreenshotProcessor()

        // MARK: Main map
        // The search field lives in the main toolbar, so its presence means the UI is up. A short
        // settle lets MapKit finish drawing tiles and annotations before capture.
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 10), "Main view did not appear")
        try? await Task.sleep(for: .seconds(2))

        capture(
            processor,
            name: "main",
            title: caption("screenshot_main_title"),
            subtitle: caption("screenshot_main_subtitle")
        )

        // MARK: Search results
        // Activate search and wait for the first mock location row (deterministic, no fixed delay).
        search.tap()
        XCTAssertTrue(
            app.staticTexts["Rapperswil, OST"].waitForExistence(timeout: 5),
            "Search results did not populate"
        )

        capture(
            processor,
            name: "search",
            title: caption("screenshot_search_title"),
            subtitle: caption("screenshot_search_subtitle")
        )

        // MARK: Location detail
        // Filter to "Bern, Aare" (the fixture with a full summary + history graph) and open it.
        search.typeText("Bern")
        let bern = app.staticTexts["Bern, Aare"]
        XCTAssertTrue(bern.waitForExistence(timeout: 5), "Bern row did not appear")
        bern.tap()

        // The history graph's back button is a stable marker that the detail has rendered; a short
        // settle then lets the chart lines animate in.
        XCTAssertTrue(
            app.buttons["HistoryGraphView_Back"].waitForExistence(timeout: 8),
            "Location detail did not render"
        )
        try? await Task.sleep(for: .seconds(1))

        capture(
            processor,
            name: "location",
            title: caption("screenshot_location_title"),
            subtitle: caption("screenshot_location_subtitle")
        )

        app.terminate()
    }

    // MARK: - Helpers

    /// Resolves a caption from this UI-test bundle's String Catalog. `String(localized:)` defaults to
    /// `Bundle.main` (the test *runner*), which does not contain these strings, so the bundle must be
    /// specified explicitly.
    private func caption(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: Bundle(for: type(of: self)))
    }

    @MainActor
    private func capture(
        _ processor: ScreenshotProcessor,
        name: String,
        title: String,
        subtitle: String?
    ) {
        let screenshot = XCUIScreen.main.screenshot()
        guard let attachment = processor.process(screenshot, name: name, content: { image, metrics in
            ScreenshotFrameView(contentImage: image, title: title, subtitle: subtitle, metrics: metrics)
        }) else {
            return
        }
        add(attachment)
    }
}
