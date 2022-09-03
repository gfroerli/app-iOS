//
//  SponsorViewModel.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import Foundation
import GfroerliAPI

@MainActor
class SponsorViewModel: ObservableObject {
    @Published var sponsor: Sponsor?
    
    init(id: Int) {
        Task {
            self.sponsor = try! await loadInitialSponsor(for: id)
        }
    }

    private func loadInitialSponsor(for id: Int) async throws -> Sponsor {
        guard let fetchedSponsor: Sponsor = try? await GfroerliAPI().load(fetchType: .sponsor(id: id)) else {
            fatalError("")
        }
        return fetchedSponsor
    }
    
    public func loadLocation(for id: Int) async throws {
        guard let fetchedSponsor: Sponsor = try? await GfroerliAPI().load(fetchType: .sponsor(id: id)) else {
            fatalError("")
        }
        sponsor = fetchedSponsor
    }
}
