//
//  GfroerliApp.swift
//  Gfroerli
//
//  Created by Marc on 08.07.2023.
//

import GfroerliBackend
import SwiftData
import SwiftUI

@main
struct GfroerliApp: App {
    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(NavigationModel())
                .environment(AllLocationsViewModel())
                .modelContainer(GfroerliBackend.modelContainer)
        }
    }
}
