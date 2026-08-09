//
//  File.swift
//  GfroerliBusiness
//
//  Created by Marc on 05.01.2026.
//

import Foundation
import GfroerliBusinessProtocols

public final class BusinessAllLocationsManagerMock: BusinessAllLocationsManagerProtocol {
    
    // MARK: - Lifecycle
    
    public init() { }
    
    // MARK: - BusinessAllLocationsManagerProtocol

    public func loadAllLocations() async throws -> [any GfroerliBusinessProtocols.BusinessLocationProtocol] {
        // A small, spread, favorites-first set: an uncluttered map and a starred-favorites search list.
        BusinessLocationMock.screenshotCuratedLocations
    }
}
