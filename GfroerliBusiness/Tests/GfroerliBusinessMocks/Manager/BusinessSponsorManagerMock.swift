//
//  BusinessSponsorManagerMock.swift
//  GfroerliBusiness
//
//  Created by Marc on 05.01.2026.
//

import Foundation
import GfroerliBusinessProtocols

public final class BusinessSponsorManagerMock: BusinessSponsorManagerProtocol, Sendable {
    
    // MARK: - Lifecycle
    
    public init() { }
    
    // MARK: - BusinessSponsorManagerProtocol

    public func loadSponsor(with locationID: Int) async throws
        -> (any GfroerliBusinessProtocols.BusinessSponsorProtocol)? {
        BusinessSponsorMock.exampleSponsor1
    }
}
