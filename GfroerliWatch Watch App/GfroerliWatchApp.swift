//
//  GfroerliWatchApp.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 26.05.2024.
//

import GfroerliBackend
import SwiftUI

@main
struct GfroerliWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            WatchMainView()
                .environment(AllLocationsViewModel())
        }
    }
}
