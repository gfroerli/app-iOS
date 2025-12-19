//
//  WatchLocationDetailViewModel.swift
//  Gfroerli
//
//  Created by Marc on 31.12.2025.
//

import Foundation
import GfroerliBusiness
import GfroerliBusinessProtocols

@Observable
@MainActor
final class WatchLocationDetailViewModel {
    
    // MARK: - Observed properties

    var location: BusinessLocationProtocol?
    var sponsor: BusinessSponsorProtocol?
    
    @ObservationIgnored
    let locationID: Int
  
    // MARK: - Private properties

    @ObservationIgnored
    private let locationManager = BusinessLocationManager()
    @ObservationIgnored
    private let sponsorManager = BusinessSponsorManager()
    
    // MARK: - Lifecycle
    
    init(locationID: Int) {
        self.locationID = locationID
    }
    
    // MARK: - Public functions

    func loadLocation() async throws {
        Task.detached {
            let fetchedLocation = try await self.locationManager.loadLocation(with: self.locationID)
           
            var fetchedSponsor: BusinessSponsorProtocol?
            if fetchedLocation?.sponsorID != nil {
                fetchedSponsor = try await self.sponsorManager.loadSponsor(with: self.locationID)
            }
            
            Task { @MainActor in
                self.location = fetchedLocation
                self.sponsor = fetchedSponsor
            }
        }
    }
}
