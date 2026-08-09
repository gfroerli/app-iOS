//
//  File.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation
import GfroerliBusinessProtocols

public final class BusinessLocationManagerMock: BusinessLocationManagerProtocol {
    
    // MARK: - Lifecycle
    
    public init() { }
    
    // MARK: - BusinessLocationManagerProtocol

    public func loadLocation(with id: Int) async throws -> (any BusinessLocationProtocol)? {
        // Curated set so the detail fixture shares the relative date and sponsor-less treatment.
        BusinessLocationMock.screenshotCuratedLocations.first { $0.id == id } ?? BusinessLocationMock.screenshotDetail
    }
}
