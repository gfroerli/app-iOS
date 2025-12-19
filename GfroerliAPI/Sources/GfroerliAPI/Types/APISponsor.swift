//
//  APISponsor.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation
import GfroerliAPIProtocols

internal final class APISponsor: APISponsorProtocol {
   
    // MARK: - Properties

    public let id: Int
    public let name: String?
    public let description: String?
    public let imageURL: URL?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "logo_url"
    }
    
    // MARK: - Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}
