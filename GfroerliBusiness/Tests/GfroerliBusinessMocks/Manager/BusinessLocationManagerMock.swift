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
        BusinessLocationMock.exampleLocation1
    }
}
