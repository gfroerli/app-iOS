//
//  APISponsorProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation

/// Representation for Sponsors fetched from the API.
/// Contains optional values, should be validated before being used/persisted.
public protocol APISponsorProtocol: Decodable, Identifiable {
    /// The id of the sponsor, used as unique identifier
    var id: Int { get }
    /// Displayable name of the sponsor
    var name: String? { get }
    /// Brief description of the sponsor
    var description: String? { get }
    /// URL the image of the sponsor can be loaded from
    var imageURL: URL? { get }
}
