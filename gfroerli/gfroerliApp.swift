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
    
    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(navigationModel)
                .environmentObject(locationsViewModel)
                .onReceive(
                    NotificationCenter.default
                        .publisher(for: UIApplication.willEnterForegroundNotification)
                ) { _ in
                    loadAllLocations()
                }
                .task {
                    loadAllLocations()
                }
        }
    }
    
    // MARK: - Private Functions
    
    private func loadAllLocations() {
        Task {
            do {
                try await locationsViewModel.loadAllLocations()
            }
            catch {
                fatalError()
            }
        }
    }
}
