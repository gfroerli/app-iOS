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

    /// Same as name until firs space or max 8 characters
    let shortName: String
    let tempString: String
    let tempDateString: String

    public init(location: any BusinessLocationProtocol) {
        self.id = location.id
        
        self.name = location.name
        self.shortName = location.shortName
        
        self.tempString = location.lastTemperatureString
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        self.tempDateString = dateFormatter.string(from: location.lastTemperatureDate)
        
        self.displayRepresentation = DisplayRepresentation(stringLiteral: name)
    }
    
    public init(id: Int, name: String, shortName: String, tempString: String, date: Date) {
        self.id = id
        
        self.name = name
        self.shortName = shortName
        
        self.tempString = tempString
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        self.tempDateString = dateFormatter.string(from: date)
        
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
