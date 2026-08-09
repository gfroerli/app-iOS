//
//  GfroerliApp.swift
//  Gfroerli
//
//  Created by Marc on 08.07.2023.
//

import SwiftData
import SwiftUI

@main
struct GfroerliApp: App {
    // MARK: - Lifecycle

    init() {
        AppDependencies.bootstrap()
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainView()
                // Generally use rounded font
                .fontDesign(.rounded)
        }
    }
}
