//
//  APILocationProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation

/// Representation for locations fetched from the API.
/// Contains optional values, should be validated before being used/persisted.
public protocol APILocationProtocol: Decodable, Identifiable {
    /// The id of the location, used as unique identifier
    var id: Int { get }
    /// Displayable name of the location
    var name: String? { get }
    /// Displayable short name of the location, usually shorter than 4 characters
    var shortName: String? { get }
    /// Brief description of the location
    var description: String? { get }
    var latitude: Double? { get }
    var longitude: Double? { get }
    /// Date the location was created
    var creationDate: Date? { get }
    
    /// ID of the sponsor this location is sponsored by
    var sponsorID: Int? { get }
    
    var lastTemperature: Double? { get }
    var lastTemperatureDate: Date? { get }
    
    /// Highest ever recorded temperature
    var highestTemperature: Double? { get }
    /// Lowest ever recorded temperature
    var lowestTemperature: Double? { get }
    /// Average of all recorded temperatures
    var averageTemperature: Double? { get }
}
