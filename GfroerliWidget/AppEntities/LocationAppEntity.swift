//
//  LocationAppEntity.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 17.05.2024.
//

import AppIntents
import Foundation
import GfroerliBusiness
import GfroerliBusinessProtocols

public struct LocationAppEntity: AppEntity, Identifiable {
    
    public let id: Int
    
    public static let defaultQuery = LocationQuery()
    // public static let example = LocationAppEntity(location: Location.exampleLocation())
    
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "location")
    
    public let displayRepresentation: DisplayRepresentation
    let name: String
    let shortName: String
    let tempString: String
    let tempValue: Double
    let tempDateString: String
    let isActive: Bool

    public init(location: any BusinessLocationProtocol) {
        self.id = location.id
        
        self.name = location.name
        self.shortName = location.shortName
        
        self.tempString = location.lastTemperatureString
        self.tempValue = location.lastTemperature
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        self.tempDateString = dateFormatter.string(from: location.lastTemperatureDate)
        
        self.isActive = location.isActive
        self.displayRepresentation = DisplayRepresentation(stringLiteral: name)
    }
    
    public init(
        id: Int,
        name: String,
        shortName: String,
        tempString: String,
        tempValue: Double,
        date: Date,
        isActive: Bool
    ) {
        self.id = id
        
        self.name = name
        self.shortName = shortName
        
        self.tempString = tempString
        self.tempValue = tempValue

        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        self.tempDateString = dateFormatter.string(from: date)
        
        self.isActive = isActive
        
        self.displayRepresentation = DisplayRepresentation(stringLiteral: name)
    }
}

public struct LocationQuery: EntityQuery {

    public init() { }
    
    public func entities(for identifiers: [LocationAppEntity.ID]) async throws -> [LocationAppEntity] {
        let manager = BusinessAllLocationsManager()
        let locations = try await manager.loadAllLocations()
        let filtered = locations.filter { identifiers.contains($0.id) }
        return filtered.map { LocationAppEntity(location: $0) }
    }
    
    public func suggestedEntities() async throws -> [LocationAppEntity] {
        let manager = BusinessAllLocationsManager()
        let locations = try await manager.loadAllLocations()
        return locations.map { LocationAppEntity(location: $0) }
    }
    
    public func defaultResult() async -> LocationAppEntity? {
        let manager = BusinessAllLocationsManager()

        guard let location = try? await manager.loadAllLocations()
            .randomElement() else {
            return nil
        }
        
        return LocationAppEntity(location: location)
    }
}
