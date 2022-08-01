//
//  LocationViewModel.swift
//
//  Created by Marc Kramer on 13.06.22.
//

import Foundation
import GfroerliAPI

@MainActor
class AllLocationsViewModel: ObservableObject {
    @Published var allLocations: [Location] = [Location]()
    @Published var activeLocations: [Location] = [Location]()

    public func loadAllLocations() async throws {
        guard let fetchedLocations: [Location] = try? await GfroerliAPI().load(fetchType: .allLocations) else {
            fatalError("")
        }
        allLocations = fetchedLocations
        // TODO
        activeLocations = fetchedLocations
    }
}
