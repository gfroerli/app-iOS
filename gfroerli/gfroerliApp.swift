//
//  gfroerliApp.swift
//  gfroerli
//
//  Created by Marc Kramer on 12.06.22.
//

import SwiftUI

@main
/// Main entry point of the App
struct gfroerliApp: App {
    
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var locationsViewModel = AllLocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationBaseView()
                .environmentObject(navigationModel)
                .environmentObject(locationsViewModel)
                .task {
                    do {
                        // TODO: We load all locations on start-up, needs to change
                        try await locationsViewModel.loadAllLocations()
                    }
                    catch {
                        // TODO: We load all locations on start-up, needs to change
                        fatalError()
                    }
                }
        }
    }
}
