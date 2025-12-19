//
//  BusinessLocationProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation

/// Representation for locations ready to be used in UI etc.
public protocol BusinessLocationProtocol {
    /// The id of the location, used as unique identifier
    var id: Int { get }
    /// Displayable name of the location
    var name: String { get }
    /// Displayable short name of the location, usually shorter than 4 characters
    var shortName: String { get }
    /// Brief description of the location
    var description: String? { get }
    var latitude: Double { get }
    var longitude: Double { get }
    /// Date the location was created
    var creationDate: Date { get }
    
    /// ID of the sponsor this location is sponsored by
    var sponsorID: Int? { get }
    
    var lastTemperature: Double { get }
    var lastTemperatureString: String { get }
   
    var lastTemperatureDate: Date { get }
    var lastTemperatureDateString: String { get }
    
    /// Highest ever recorded temperature
    var highestTemperature: Double? { get }
    var highestTemperatureString: String { get }

    /// Lowest ever recorded temperature
    var lowestTemperature: Double? { get }
    var lowestTemperatureString: String { get }

    /// Average of all recorded temperatures
    var averageTemperature: Double? { get }
    var averageTemperatureString: String { get }

    /// Wether the location can be viewed as active
    var isActive: Bool { get }
}
