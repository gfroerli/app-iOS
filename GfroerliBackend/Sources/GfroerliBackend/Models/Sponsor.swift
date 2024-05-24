//
//  Sponsor.swift
//
//
//  Created by Marc Kramer on 08.06.23.
//

import Foundation
import SwiftData

@Model public class Sponsor {
    // MARK: SwiftData Attributes

    @Attribute(.unique) public var id: Int
    public var name: String?
    public var desc: String?
    public var imageURL: URL?

    // MARK: Lifecycle

    init(id: Int, name: String? = nil, desc: String? = nil, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.desc = desc
        self.imageURL = imageURL
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.desc = try values.decodeIfPresent(String.self, forKey: .description)
        self.imageURL = try values.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}

// MARK: - Decodable

extension Sponsor: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "logo_url"
    }
}
