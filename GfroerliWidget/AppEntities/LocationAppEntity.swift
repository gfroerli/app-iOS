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
    
    public static let defaultQuery = LocationQuery()
    public static let example = LocationAppEntity(location: Location.exampleLocation())
    
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "location")
    
    public let displayRepresentation: DisplayRepresentation
    let name: String

    /// Same as name until firs space or max 8 characters
    let shortName: String
    let tempString: String
    let tempDateString: String

    public init(location: Location) {
        self.id = location.id
        
        self.name = location.name ?? ""
        let delimiter = " "
        let splits = name.components(separatedBy: delimiter)
        self.shortName = String((splits.first ?? "").prefix(8))
        
        self.tempString = location.latestTemperatureString
        
        if let date = location.lastTemperatureDate {
            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.locale = Locale.current
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            self.tempDateString = dateFormatter.string(from: date)
        }
        else {
            self.tempDateString = String(localized: "widget_no_date")
        }
        
        self.displayRepresentation = DisplayRepresentation(stringLiteral: name)
    }
}

public struct LocationQuery: EntityQuery {

    public init() { }
    
    public func entities(for identifiers: [LocationAppEntity.ID]) async throws -> [LocationAppEntity] {
        let locationsVM = await AllLocationsViewModel()
        await locationsVM.loadAllLocations()
        let filtered = await locationsVM.allLocations.filter { identifiers.contains($0.id) }
        return filtered.map { LocationAppEntity(location: $0) }
    }
    
    public func suggestedEntities() async throws -> [LocationAppEntity] {
        let locationsVM = await AllLocationsViewModel()
        await locationsVM.loadAllLocations()
        let locations = await locationsVM.allLocations
        return locations.map { LocationAppEntity(location: $0) }
    }
    
    public func defaultResult() async -> LocationAppEntity? {
        let locationsVM = await AllLocationsViewModel()
        await locationsVM.loadAllLocations()

        guard let location = await locationsVM.activeLocations.randomElement() else {
            return nil
        }
        
        return LocationAppEntity(location: location)
    }
}
