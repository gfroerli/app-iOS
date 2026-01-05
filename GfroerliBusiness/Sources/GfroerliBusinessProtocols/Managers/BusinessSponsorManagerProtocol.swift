//
//  BusinessSponsorManagerProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation

public protocol BusinessSponsorManagerProtocol: Sendable {
    func loadSponsor(with locationID: Int) async throws -> BusinessSponsorProtocol?
}
