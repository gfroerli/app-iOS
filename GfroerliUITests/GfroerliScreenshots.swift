//
//  GfroerliScreenshots.swift
//  GfroerliUITests
//
//  Created by Marc on 26.11.2023.
//

import ScreenshotKit
import XCTest

final class GfroerliScreenshots: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    @MainActor
    func testExample() async throws {
        let app = XCUIApplication()
        app.launch()
        let screenshotpcssr = ScreenshotProcessor()
        // if we don't set lifetime to .keepAlways, Xcode will delete the image if the test passes.

        // Dismiss whats new
        let button1 = app.buttons["newFeaturesView_dismiss"]
        if button1.waitForExistence(timeout: 3) {
            button1.tap()
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let mainScreenshot = XCUIScreen.main.screenshot()
        let mainScreenshotProcessed = screenshotpcssr.process(mainScreenshot, type: .main)
        add(mainScreenshotProcessed)
        
        let search = app.searchFields.firstMatch
        if search.waitForExistence(timeout: 3) {
            search.tap()
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let searchScreenshot = XCUIScreen.main.screenshot()
        let searchScreenshotProcessed = screenshotpcssr.process(searchScreenshot, type: .search)
        add(searchScreenshotProcessed)
        
        let element = app.staticTexts["Kempraten"]
        if element.waitForExistence(timeout: 3) {
            element.tap()
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let locationScreenshot = XCUIScreen.main.screenshot()
        let locationScreenshotProcessed = screenshotpcssr.process(locationScreenshot, type: .location)
        add(locationScreenshotProcessed)
        app.terminate()
    }
}
