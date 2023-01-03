//
//  SingleLocationViewModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import Foundation
import GfroerliAPI

/// ViewModel handling loading and refreshing of single Locations
class SingleLocationsViewModel: ObservableObject {

    private var id: Int
    
    // MARK: - Lifecycle

    /// Initializer
    /// - Parameter id: ID of the Location to be loaded
    init(id: Int) {
        self.id = id
        self.modelState = .initial

        loadLocation()
    }

    // MARK: - Published Properties
    
    @Published var location: Location?

    @Published var modelState: ViewModelState

    // MARK: - Public Functions
    
    public func loadLocation() {
        assignLocation(nil, newState: .loading)

        Task {
            guard let fetchedLocation: Location = try? await GfroerliAPI().load(fetchType: .singleLocation(id: id))
            else {
                // TODO: Error Handling
                assignLocation(nil, newState: .failed(error: .otherError))
                return
            }
            
            assignLocation(fetchedLocation, newState: .loaded)
        }
    }
    
    // MARK: - Private Functions

    private func assignLocation(_ fetchedLocation: Location?, newState: ViewModelState) {
        Task { @MainActor in
            modelState = newState
            location = fetchedLocation
        }
    }
}
