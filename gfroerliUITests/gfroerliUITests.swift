//
//  gfroerliUITests.swift
//  gfroerliUITests
//
//  Created by Marc Kramer on 12.06.22.
//

import SwiftUI
import XCTest

final class gfroerliUITests: XCTestCase {
    func testMainScreen() throws {
        let localizations = [Localization(locale: "en", title: "WOW")]
        
        for localization in localizations {
            let app = XCUIApplication()
            //  app.launchArguments = ["-AppleLanguages", "\(localization.locale)"]
            app.launch()
            
            let screenshot = app.screenshot()
            let view = ScreenshotWithTitle(
                title: "###",
                image: Image(uiImage: screenshot.image),
                background: .color(.blue),
                exportSize: .iPhone
            )
            let attachment = createMarketing(image: view, exportSize: .iPhone)
            
            add(attachment)
            
            app.terminate()
        }
    }
}
