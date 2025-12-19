//
//  BusinessSponsorProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation

/// Representation for sponsors ready to be used in UI etc.
public protocol BusinessSponsorProtocol {
    /// The id of the sponsor, used as unique identifier
    var id: Int { get }
    /// Displayable name of the sponsor
    var name: String { get }
    /// Brief description of the sponsor
    var description: String { get }
    /// URL the image of the sponsor can be loaded from
    var imageURL: URL { get }
}
