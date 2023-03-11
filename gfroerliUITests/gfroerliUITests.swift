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
            
            sleep(5)
            let screenshot = app.screenshot()
            let view = ScreenshotWithTitle(
                title: "Gfrör.li ",
                image: Image(uiImage: screenshot.image),
                exportSize: .iPhone6_5
            )
            let attachment = createMarketing(image: view, exportSize: .iPhone6_5)
            
            print(attachment.userInfo)
            add(attachment)
            
            app.terminate()
        }
    }
}
