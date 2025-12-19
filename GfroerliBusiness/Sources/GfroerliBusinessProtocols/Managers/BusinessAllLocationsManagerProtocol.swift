//
//  BusinessAllLocationsManagerProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 23.12.2025.
//

import Foundation

public protocol BusinessAllLocationsManagerProtocol: Sendable {
    func loadAllLocations() async throws -> [BusinessLocationProtocol]
}
