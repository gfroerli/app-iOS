//
//  SponsorViewModel.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import Foundation
import GfroerliBackend

/// ViewModel handling loading and refreshing of Sponsors
class SponsorViewModel: ObservableObject {
    
    private var id: Int
    
    // MARK: - Lifecycle
    
    /// Initializer
    /// - Parameter id: ID of the Sponsor to be loaded
    init(id: Int) {
        self.id = id
        self.modelState = .initial
        
        loadSponsor()
    }

    // MARK: - Published Properties

    @Published var sponsor: Sponsor?
    
    @Published var modelState: ViewModelState
    
    // MARK: - Public Functions
    
    /// Loads the Sponsor with the ID the ViewModel was initialized with
    public func loadSponsor() {
        assignSponsor(nil, newState: .loading)

        Task {
            guard let fetchedSponsor: Sponsor = try? await GfroerliBackend().load(fetchType: .sponsor(id: id)) else {
                // TODO: Error Handling
                assignSponsor(nil, newState: .failed(error: .otherError))
                return
            }
            assignSponsor(fetchedSponsor, newState: .loaded)
        }
    }
    
    // MARK: - Private Functions
    
    private func assignSponsor(_ fetchedSponsor: Sponsor?, newState: ViewModelState) {
        Task { @MainActor in
            modelState = newState
            sponsor = fetchedSponsor
        }
    }
}
