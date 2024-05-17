//
//  LocationAppEntity.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 17.05.2024.
//

import AppIntents
import Foundation
import GfroerliBackend

public struct LocationAppEntity: AppEntity, Identifiable {
    
    public let id: Int
    let name: String
    let tempString: String
    let lastTempDateString: String

    public init(location: Location) {
        self.id = location.id
        self.name = location.name ?? "NIL"
        self.tempString = location.latestTemperatureString
        self.lastTempDateString = location.lastTemperatureDateString
    }

    @MainActor
    public static var defaultQuery = LocationQuery()

    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "location")
    }
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: name)
    }

    public static var example = LocationAppEntity(location: Location.exampleLocation())
}

public struct LocationQuery: EntityQuery {
    private let locationsVM: AllLocationsViewModel

    @MainActor
    public init() {
        self.locationsVM = AllLocationsViewModel()
    }
    
    public func entities(for identifiers: [LocationAppEntity.ID]) async throws -> [LocationAppEntity] {
        let filtered = await locationsVM.allLocations.filter { identifiers.contains($0.id) }
        return filtered.map { LocationAppEntity(location: $0) }
    }
    
    public func suggestedEntities() async throws -> [LocationAppEntity] {
        let locations = await locationsVM.allLocations
        return locations.map { LocationAppEntity(location: $0) }
    }
    
    public func defaultResult() async -> LocationAppEntity? {
        guard let location = await locationsVM.activeLocations.randomElement() else {
            return nil
        }
        
        return LocationAppEntity(location: location)
    }
}
