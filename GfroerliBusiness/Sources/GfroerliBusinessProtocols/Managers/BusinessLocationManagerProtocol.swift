//
//  BusinessLocationManagerProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation

public protocol BusinessLocationManagerProtocol: Sendable {
    func loadLocation(with id: Int) async throws -> BusinessLocationProtocol?
}
