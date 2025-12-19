//
//  BusinessSponsorManager.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliAPI
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

public final class BusinessSponsorManager: BusinessSponsorManagerProtocol, Sendable {
    
    // MARK: - Private properties
    
    private let apiCaller: any GfroerliAPICallerProtocol
    private let sponsorValidator: SponsorValidator
    
    // MARK: - Lifecycle
    
    init(apiCaller: any GfroerliAPICallerProtocol, sponsorValidator: any ValidatorProtocol) {
        self.apiCaller = apiCaller
        self.sponsorValidator = sponsorValidator as! SponsorValidator
    }
    
    public convenience init() {
        self.init(apiCaller: GfroerliAPICaller(), sponsorValidator: SponsorValidator())
    }
    
    // MARK: - BusinessSponsorManagerProtocol

    public func loadSponsor(with locationID: Int) async throws -> (any BusinessSponsorProtocol)? {
        let apiSponsor: any APISponsorProtocol = try await apiCaller.getRemoteSponsor(with: locationID)
        let validatedSponsor = sponsorValidator.validate(apiSponsor)

        return validatedSponsor
    }
}
