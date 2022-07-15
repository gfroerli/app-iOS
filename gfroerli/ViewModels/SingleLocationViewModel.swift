//
//  SingleLocationViewModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import Foundation
import GfroerliAPI

@MainActor
class SingleLocationsViewModel: ObservableObject {
    @Published var location: Location
    
    init(id: Int) {
        location = Location.example()
        Task {
            self.location = try! await loadInitialLocation(for: id)
        }
    }

    private func loadInitialLocation(for id: Int) async throws -> Location{
        guard let fetchedLocation = try? await GfroerliAPI().load(type: Location.self, fetchType: .singleLocation(id: id)) else {
            fatalError("")
        }
        return fetchedLocation
    }
    
    public func loadLocation(for id: Int) async throws {
        guard let fetchedLocation = try? await GfroerliAPI().load(type: Location.self, fetchType: .singleLocation(id: id)) else {
            fatalError("")
        }
        location = fetchedLocation
    }
}
