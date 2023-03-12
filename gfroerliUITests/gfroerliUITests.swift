//
//  gfroerliUITests.swift
//  gfroerliUITests
//
//  Created by Marc Kramer on 12.06.22.
//

import SwiftUI
import XCTest

final class gfroerliUITests: XCTestCase {
    
    var sheetGrabberName: String {
        if Locale.current.language.languageCode == "de" {
            return "Aufzeichnungsblatt"
        }
        else if Locale.current.language.languageCode == "en" {
            return "Sheet Grabber"
        }
        return ""
    }

    let exportSize = ExportSize.iPhone5_5
    
    func testMainScreen() throws {
        
        UIView.setAnimationsEnabled(false)
        
        let app = XCUIApplication()
        app.launchEnvironment = ["DISABLE_ANIMATIONS": "1"]
        app.launch()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        app.launch()
        sleep(5)
        
        // Workaround to make center map work on simulator
        app.swipeLeft()
        app.buttons["LocationMapView_Zoom"].tap()
        sleep(1) // Wait for animation
        
        // Overview
        let screenshotOverview = app.screenshot()
        let viewOverview = ScreenshotWithTitle(
            image: Image(uiImage: screenshotOverview.image),
            exportSize: exportSize, content: .overview
        )
        let attachmentOverview = createMarketing(
            image: viewOverview,
            name: "overview_\(Locale.current.language.languageCode!.identifier)",
            exportSize: exportSize
        )
        add(attachmentOverview)
        
        // Search
        app.buttons[sheetGrabberName].tap()
        sleep(1) // Wait for animation

        let screenshotSearch = app.screenshot()
        let viewSearch = ScreenshotWithTitle(
            image: Image(uiImage: screenshotSearch.image),
            exportSize: exportSize, content: .search
        )
        let attachmentSearch = createMarketing(
            image: viewSearch,
            name: "search_\(Locale.current.language.languageCode!.identifier)",
            exportSize: exportSize
        )
        add(attachmentSearch)
        
        // Detail
        app.staticTexts["Kempraten"].tap()
        app.buttons["HistoryGraphView_Back"].tap(withNumberOfTaps: 8, numberOfTouches: 1)
        sleep(1) // Wait for animation
        
        let screenshotDetail = app.screenshot()
        let viewDetail = ScreenshotWithTitle(
            image: Image(uiImage: screenshotDetail.image),
            exportSize: exportSize, content: .detail
        )
        let attachmentDetail = createMarketing(
            image: viewDetail,
            name: "detail_\(Locale.current.language.languageCode!.identifier)",
            exportSize: exportSize
        )
        add(attachmentDetail)
        
        app.terminate()
    }
}
