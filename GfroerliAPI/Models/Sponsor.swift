//
//  Sponsor.swift
//
//
//  Created by Marc Kramer on 13.06.22.
//

import Foundation

public struct Sponsor: Identifiable, Equatable {
    
    public let id: Int
    let jName: String?
    let jDescription: String?
    public let logoURL: URL?
    
    // MARK: - Lifecycle
    
    init(id: Int, jName: String? = nil, jDescription: String? = nil, logoURL: URL? = nil) {
        self.id = id
        self.jName = jName
        self.jDescription = jDescription
        self.logoURL = logoURL
    }
}

// MARK: - Unwrapping

public extension Sponsor {
    /// Name of the Sponsor
    var name: String {
        jName ?? "No Name"
    }
    
    /// Short description of the Sponsor
    var description: String {
        jDescription ?? "No Description"
    }
}

// MARK: - Codable

extension Sponsor: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case jName = "name"
        case jDescription = "description"
        case logoURL = "logo_url"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.jName = try values.decodeIfPresent(String.self, forKey: .jName)
        self.jDescription = try values.decodeIfPresent(String.self, forKey: .jDescription)
        self.logoURL = try values.decodeIfPresent(URL.self, forKey: .logoURL)
    }
}

// MARK: - Example

public extension Sponsor {
    static func exampleSponsor() -> Sponsor {
        Sponsor(
            id: 0,
            jName: "Test Sponsor",
            jDescription: "Test Sponsor Description",
            logoURL: URL(string: "www.gfoer.li")!
        )
    }
}
