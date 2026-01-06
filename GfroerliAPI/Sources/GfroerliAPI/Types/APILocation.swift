//
//  APILocation.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation
import GfroerliAPIProtocols

internal struct APILocation: APILocationProtocol, Decodable {
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String?
    public let shortName: String?
    public let description: String?
    public let latitude: Double?
    public let longitude: Double?
    public let creationDate: Date?

    public let sponsorID: Int?

    public let lastTemperature: Double?
    public let lastTemperatureDate: Date?

    public let highestTemperature: Double?
    public let lowestTemperature: Double?
    public let averageTemperature: Double?

    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id

        case name = "device_name"
        case shortName = "shortname"
        case description = "caption"
        case latitude
        case longitude
        case creationDate = "created_at"

        case sponsorID = "sponsor_id"

        case lastTemperature = "latest_temperature"
        case lastTemperatureDate = "latest_measurement_at"

        // These are only present when fetching an individual location
        case highestTemperature = "maximum_temperature"
        case lowestTemperature = "minimum_temperature"
        case averageTemperature = "average_temperature"
    }
    
    // MARK: - Lifecycle
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)

        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)

        self.sponsorID = try container.decodeIfPresent(Int.self, forKey: .sponsorID)

        self.lastTemperature = try container.decodeIfPresent(Double.self, forKey: .lastTemperature)
        self.lastTemperatureDate = try container.decodeIfPresent(Date.self, forKey: .lastTemperatureDate)

        self.highestTemperature = try container.decodeIfPresent(Double.self, forKey: .highestTemperature)
        self.lowestTemperature = try container.decodeIfPresent(Double.self, forKey: .lowestTemperature)
        self.averageTemperature = try container.decodeIfPresent(Double.self, forKey: .averageTemperature)
    }
}
