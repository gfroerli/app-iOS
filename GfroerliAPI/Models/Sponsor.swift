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
    public let logoUrl: URL?
    
    // MARK: - Lifecycle
    
    init(id: Int, jName: String? = nil, jDescription: String? = nil, logoUrl: URL? = nil) {
        self.id = id
        self.jName = jName
        self.jDescription = jDescription
        self.logoUrl = logoUrl
    }
}

// MARK: - Unwrapping

extension Sponsor {
    /// Name of the Sponsor
    public var name: String {
        jName ?? "No Name"
    }
    
    /// Short description of the Sponsor
    public var description: String {
        jDescription ?? "No Description"
    }
}

// MARK: - Codable
extension Sponsor: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case jName = "name"
        case jDescription = "description"
        case logoUrl = "logo_url"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        jName = try values.decodeIfPresent(String.self, forKey: .jName)
        jDescription = try values.decodeIfPresent(String.self, forKey: .jDescription)
        logoUrl = try values.decodeIfPresent(URL.self, forKey: .logoUrl)
    }
}


// MARK: - Example
extension Sponsor {
    public static func exampleSponsor() -> Sponsor {
        Sponsor(id: 0, jName: "Test Sponsor", jDescription: "Test Sponsor Description", logoUrl: URL(string: "www.gfoer.li")!)
    }
}
