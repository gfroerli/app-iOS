//
//  Location.swift
//
//
//  Created by Marc Kramer on 08.06.23.
//

import CoreLocation
import Foundation
import Observation

public final class Location: Identifiable, Equatable, Hashable, Sendable {
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs === rhs
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public let id: Int
    public let name: String?
    public let desc: String?
    public let latitude: Double?
    public let longitude: Double?
    public let creationDate: Date?

    public let sponsorID: Int?

    public let latestTemperature: Double?
    public let lastTemperatureDate: Date?

    public let highestTemperature: Double?
    public let lowestTemperature: Double?
    public let averageTemperature: Double?

    public let lastFetchDate: Date

    // MARK: Lifecycle

    init(
        id: Int,
        name: String? = nil,
        desc: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        creationDate: Date? = nil,
        sponsorID: Int? = nil,
        latestTemperature: Double? = nil,
        lastTemperatureDate: Date? = nil,
        highestTemperature: Double? = nil,
        lowestTemperature: Double? = nil,
        averageTemperature: Double? = nil,
        lastFetchDate: Date = Date.distantPast
    ) {
        self.id = id
        self.name = name
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.creationDate = creationDate
        self.sponsorID = sponsorID
        self.latestTemperature = latestTemperature
        self.lastTemperatureDate = lastTemperatureDate
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
        self.averageTemperature = averageTemperature
        self.lastFetchDate = lastFetchDate
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)

        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.desc = try container.decodeIfPresent(String.self, forKey: .description)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)

        self.sponsorID = try container.decodeIfPresent(Int.self, forKey: .sponsorID)

        self.latestTemperature = try container.decodeIfPresent(Double.self, forKey: .latestTemperature)
        self.lastTemperatureDate = try container.decodeIfPresent(Date.self, forKey: .lastTemperatureDate)

        self.highestTemperature = try container.decodeIfPresent(Double.self, forKey: .highestTemperature)
        self.lowestTemperature = try container.decodeIfPresent(Double.self, forKey: .lowestTemperature)
        self.averageTemperature = try container.decodeIfPresent(Double.self, forKey: .averageTemperature)
        self.lastFetchDate = Date.now
    }
}

// MARK: - Unwrapping

extension Location {
//
//    /// Name of the Location
//    var name: String {
//        name ?? "No Name"
//    }
//
//    /// Short description of the Location
//    var description: String {
//        jDescription ?? "No Description"
//    }

    /// Created CLLocation of Location
    public var coordinates: CLLocation? {
        guard let lat = latitude,
              let long = longitude
        else {
            return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }

//    var lastTemperatureDate: Date {
//        lastTemperatureDate ?? Date(timeIntervalSinceReferenceDate: 0)
//    }

    public var isActive: Bool {
        DateUtil.wasInLast72Hours(givenDate: lastTemperatureDate!)
    }

    /// String of  date of last measurement relative to now
    public var lastTemperatureDateString: String {
        guard let lastTemperatureDate else {
            return "Unknown"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: lastTemperatureDate, relativeTo: .now)
    }

    public var latestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: latestTemperature)
    }

    public var lowestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: lowestTemperature)
    }

    public var averageTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: averageTemperature)
    }

    public var highestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: highestTemperature)
    }
}

// MARK: - Decodable

extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case id

        case name = "device_name"
        case description = "caption"
        case latitude
        case longitude
        case creationDate = "created_at"

        case sponsorID = "sponsor_id"

        case latestTemperature = "latest_temperature"
        case lastTemperatureDate = "latest_measurement_at"

        case highestTemperature = "maximum_temperature"
        case lowestTemperature = "minimum_temperature"
        case averageTemperature = "average_temperature"
    }
}

// MARK: - Example

extension Location {
    public nonisolated static func exampleLocation() -> Location {
        Location(
            id: 7,
            name: "Test Location",
            desc: "This is just a description for the test location",
            latitude: 47.0,
            longitude: 8.0,
            creationDate: Date.now,
            sponsorID: 0,
            latestTemperature: 20.5,
            lastTemperatureDate: Date.now,
            highestTemperature: 20.0,
            lowestTemperature: 10.5,
            averageTemperature: 15.5
        )
    }

    public static func inactiveExampleLocation() -> Location {
        Location(
            id: 0,
            name: "Test Inactive Location",
            desc: "This is just a description for the test location",
            latitude: 47.0,
            longitude: 8.0,
            creationDate: Date.now,
            sponsorID: 0,
            latestTemperature: 20.5,
            lastTemperatureDate: Date.distantPast,
            highestTemperature: 20.0,
            lowestTemperature: 10.5,
            averageTemperature: 15.5
        )
    }
}
