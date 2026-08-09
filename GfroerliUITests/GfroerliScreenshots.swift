//
//  GfroerliScreenshots.swift
//  GfroerliUITests
//
//  Created by Marc on 26.11.2023.
//

import ScreenshotKit
import SwiftUI
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

        // The search field lives in the main toolbar, so its presence means the UI is up. MapKit then
        // needs a few seconds to fetch and draw its tiles; too short a settle captures the empty tile
        // grid (no map), so wait long enough for the tiles to render before capture.
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 10), "Main view did not appear")
        try? await Task.sleep(for: .seconds(6))

        capture(
            processor,
            name: "main",
            title: caption("screenshot_main_title"),
            subtitle: caption("screenshot_main_subtitle"),
            layout: ScreenshotLayout(captionPlacement: .top, showsBrand: true, columnIndex: 0)
        )

        // MARK: Search results

        // Activate search and wait for the first favourite row (favourites lead the list in screenshot
        // mode, so this both confirms the results populated and that the starred rows are on top).
        search.tap()
        XCTAssertTrue(
            app.staticTexts["Zürich, Sihl"].waitForExistence(timeout: 5),
            "Search results did not populate"
        )

        // On iPhone, lower the keyboard so the shot shows the full list: a short downward drag over the
        // results triggers `.scrollDismissesKeyboard` while search — and the results — stay active.
        //
        // iPad is deliberately left with the keyboard up. There, *any* drag over the results cancels the
        // whole search (revealing the bare map), and the keyboard's dismiss key can't be tapped reliably
        // in the rotated landscape coordinate space. With the keyboard up the "Results" header and the
        // starred favourites still sit well above it, so the favourites list reads clearly.
        if UIDevice.current.userInterfaceIdiom != .pad {
            let dragStart = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.30))
            let dragEnd = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.55))
            dragStart.press(forDuration: 0.1, thenDragTo: dragEnd)
        }
        try? await Task.sleep(for: .seconds(1))

        // Guard against a regression where dismissing the keyboard also cancels search (which would
        // capture the bare map instead of the favourites list): the starred row must still be present.
        XCTAssertTrue(
            app.staticTexts["Zürich, Sihl"].exists,
            "Search results list disappeared before the favourite screenshot was captured"
        )

        capture(
            processor,
            name: "favorite",
            title: caption("screenshot_favorite_title"),
            subtitle: caption("screenshot_favorite_subtitle"),
            layout: ScreenshotLayout(captionPlacement: .top, showsBrand: false, columnIndex: 1)
        )

        // MARK: Location detail

        // Filter to "Bern, Aare" (the fixture with a full summary + history graph) and open it.
        // Re-focus the field first — the earlier keyboard dismissal resigned its first responder.
        search.tap()
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
            subtitle: caption("screenshot_location_subtitle"),
            layout: ScreenshotLayout(captionPlacement: .top, showsBrand: false, columnIndex: 2)
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
        subtitle: String?,
        layout: ScreenshotLayout
    ) {
        let screenshot = XCUIScreen.main.screenshot()
        guard let attachment = processor.process(screenshot, name: name, content: { image, metrics in
            ScreenshotFrameView(
                contentImage: image,
                title: title,
                subtitle: subtitle,
                layout: layout,
                metrics: metrics
            )
        }) else {
            return
        }
        add(attachment)
    }
}
