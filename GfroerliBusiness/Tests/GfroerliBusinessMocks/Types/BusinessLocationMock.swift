//
//  BusinessLocationMock.swift
//  GfroerliBusiness
//
//  Created by Marc on 05.01.2026.
//

import Foundation
import GfroerliBusinessProtocols

public struct BusinessLocationMock: BusinessLocationProtocol, Sendable {
    
    // MARK: - BusinessLocationProtocol

    public var id: Int
    
    public var name: String
    
    public var shortName: String
    
    public var description: String?
    
    public var latitude: Double
    
    public var longitude: Double
    
    public var creationDate: Date
    
    public var sponsorID: Int?
    
    public var lastTemperature: Double
    
    public var lastTemperatureString: String
    
    public var lastTemperatureDate: Date
    
    public var lastTemperatureDateString: String
    
    public var highestTemperature: Double?
    
    public var highestTemperatureString: String
    
    public var lowestTemperature: Double?
    
    public var lowestTemperatureString: String
    
    public var averageTemperature: Double?
    
    public var averageTemperatureString: String
    
    public var isActive: Bool
    
    // MARK: - Example Locations
    
    public static let exampleLocation1 = BusinessLocationMock(
        id: 0,
        name: "Test Location1",
        shortName: "TST",
        description: "This is a simple test location.",
        latitude: 47.222206999999997,
        longitude: 8.8157829999999997,
        creationDate: .distantPast,
        sponsorID: 0,
        lastTemperature: 25.0,
        lastTemperatureString: "",
        lastTemperatureDate: .now,
        lastTemperatureDateString: "now",
        highestTemperature: 35.0,
        highestTemperatureString: "",
        lowestTemperature: -0.1,
        lowestTemperatureString: "",
        averageTemperature: 20.5,
        averageTemperatureString: "",
        isActive: true
    )
    
    public static let exampleLocation2 = BusinessLocationMock(
        id: 1,
        name: "Test Location2 ",
        shortName: "TST",
        description: "This is a simple test location.",
        latitude: 47.252206999999997,
        longitude: 8.8557829999999997,
        creationDate: .distantPast,
        sponsorID: 0,
        lastTemperature: 25.0,
        lastTemperatureString: "",
        lastTemperatureDate: .now,
        lastTemperatureDateString: "now",
        highestTemperature: 35.0,
        highestTemperatureString: "",
        lowestTemperature: -0.1,
        lowestTemperatureString: "",
        averageTemperature: 20.5,
        averageTemperatureString: "",
        isActive: true
    )
}
