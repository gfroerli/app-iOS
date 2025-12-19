//
//  WatchMainViewModel.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 31.12.2025.
//

import Foundation
import GfroerliBusiness
import GfroerliBusinessProtocols

@Observable
@MainActor
final class MainMapViewModel {
    
    // MARK: - Observed properties

    /// Locations that were loaded from backend
    private(set) var activeLocations = [BusinessLocationProtocol]()
    private(set) var inactiveLocations = [BusinessLocationProtocol]()

    // MARK: - Private properties

    @ObservationIgnored
    private let allLocationsManager = BusinessAllLocationsManager()
    
    // MARK: - Lifecycle
    
    init() { }
    
    // MARK: - Public functions
    
    func loadLocations() async throws {
        Task.detached {
            let fetched = try await self.allLocationsManager.loadAllLocations()
            Task { @MainActor in
                self.activeLocations = fetched.filter(\.isActive)
                self.inactiveLocations = fetched.filter { !$0.isActive }
            }
        }
    }
}
