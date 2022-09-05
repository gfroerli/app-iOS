//
//  Location.swift
//
//
//  Created by Marc Kramer on 12.06.22.
//

import CoreLocation
import Foundation

public struct Location: Equatable, Identifiable, Hashable {
    
    // MARK: Properties

    public let id: Int
    let jName: String?
    let jDescription: String?
    let jLatitude: Double?
    let jLongitude: Double?
    public let creationDate: Date?
    
    public let sponsorID: Int?
    
    public let latestTemperature: Double?
    public let lastTemperatureDate: Date?
    
    public let highestTemperature: Double?
    public let lowestTemperature: Double?
    public let averageTemperature: Double?
    
    // MARK: Lifecycle

    init(
        id: Int,
        jName: String? = nil,
        jDescription: String? = nil,
        jLatitude: Double? = nil,
        jLongitude: Double? = nil,
        creationDate: Date? = nil,
        sponsorID: Int? = nil,
        latestTemperature: Double? = nil,
        lastTemperatureDate: Date? = nil,
        highestTemperature: Double? = nil,
        lowestTemperature: Double? = nil,
        averageTemperature: Double? = nil
    ) {
        self.id = id
        self.jName = jName
        self.jDescription = jDescription
        self.jLatitude = jLatitude
        self.jLongitude = jLongitude
        self.creationDate = creationDate
        self.sponsorID = sponsorID
        self.latestTemperature = latestTemperature
        self.lastTemperatureDate = lastTemperatureDate
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
        self.averageTemperature = averageTemperature
    }
}

// MARK: - Unwrapping

public extension Location {
    
    /// Name of the Location
    var name: String {
        jName ?? "No Name"
    }
    
    /// Short description of the Location
    var description: String {
        jDescription ?? "No Description"
    }
    
    /// Created CLLocation of Location
    var coordinates: CLLocation? {
        guard let lat = jLatitude,
              let long = jLongitude else {
            return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }
    
    /// String of  date of last measurement relative to now
    var lastTemperatureDateString: String {
        guard let lastTemperatureDate else {
            return "Unknown"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: lastTemperatureDate, relativeTo: .now)
    }
    
    var latestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: latestTemperature)
    }
    
    var lowestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: lowestTemperature)
    }
    
    var averageTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: averageTemperature)
    }
    
    var highestTemperatureString: String {
        MeasurementUtils.shared.temperatureString(from: highestTemperature)
    }
}

// MARK: - Codable

extension Location: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        
        case jName = "device_name"
        case jDescription = "caption"
        case jLatitude = "latitude"
        case jLongitude = "longitude"
        case creationDate = "created_at"
        
        case sponsorID = "sponsor_id"
        
        case latestTemperature = "latest_temperature"
        case lastTemperatureDate = "latest_measurement_at"
        
        case highestTemperature = "maximum_temperature"
        case lowestTemperature = "minimum_temperature"
        case averageTemperature = "average_temperature"
    }
    
    // MARK: - Decoder

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        self.jName = try container.decodeIfPresent(String.self, forKey: .jName)
        self.jDescription = try container.decodeIfPresent(String.self, forKey: .jDescription)
        self.jLatitude = try container.decodeIfPresent(Double.self, forKey: .jLatitude)
        self.jLongitude = try container.decodeIfPresent(Double.self, forKey: .jLongitude)
        self.creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)
        
        self.sponsorID = try container.decodeIfPresent(Int.self, forKey: .sponsorID)
        
        self.latestTemperature = try container.decodeIfPresent(Double.self, forKey: .latestTemperature)
        self.lastTemperatureDate = try container.decodeIfPresent(Date.self, forKey: .lastTemperatureDate)
        
        self.highestTemperature = try container.decodeIfPresent(Double.self, forKey: .highestTemperature)
        self.lowestTemperature = try container.decodeIfPresent(Double.self, forKey: .lowestTemperature)
        self.averageTemperature = try container.decodeIfPresent(Double.self, forKey: .averageTemperature)
    }
}

// MARK: - Example

public extension Location {
    static func exampleLocation() -> Location {
        Location(
            id: 0,
            jName: "Test Location",
            jDescription: "This is just a description for the test location",
            jLatitude: 47.0,
            jLongitude: 8.0,
            creationDate: Date.now,
            sponsorID: 0,
            latestTemperature: 20.5,
            lastTemperatureDate: Date.now,
            highestTemperature: 20.0,
            lowestTemperature: 10.5,
            averageTemperature: 15.5
        )
    }
}
