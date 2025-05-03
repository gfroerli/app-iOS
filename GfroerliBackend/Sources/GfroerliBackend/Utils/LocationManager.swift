//
//  LocationManager.swift
//
//
//  Created by Marc on 10.06.2023.
//

import Foundation
import SwiftData

@MainActor
class LocationManager {
    static let shared = LocationManager()

    // MARK: - Private Properties

    private let context = GfroerliBackend.modelContainer.mainContext
    
    private let useCache = false // UserDefaults.standard.bool(forKey: "UseCache")

    // MARK: - Public Functions

    public func location(for id: Int) async -> Location? {
        // Try to load from SwiftData
//        if useCache, var dbLocation = loadLocationFromDB(id: id) {
//            // We check if the date we last tried to update the location, is smaller then the defined interval
//            if dbLocation.lastFetchDate < Date.now.addingTimeInterval(-60) {
//                await refreshLocation(location: &dbLocation)
//            }
//            return dbLocation
//        }

        // If non-existent in SwiftData we newly load from API
        guard let fetchedLocation = await loadLocationFromAPI(id: id) else {
            // TODO: Error handling
            return nil
        }

        persistAndAssign(fetchedLocation)

        return fetchedLocation
    }

    public func loadAllLocations() async -> [Location]? {
        let dbLocations = loadAllLocationsFromDB()
        let fetchedLocations = await loadAllLocationsFromAPI() ?? [Location]()

        var allLocations = [Location]()
        for location in fetchedLocations {
            guard useCache, let dbLocation = dbLocations?.first(where: { dbLoc in
                dbLoc.id == location.id
            }) else {
                persistAndAssign(location)
                allLocations.append(location)
                continue
            }
            // await refreshLocation(location: &dbLocation)
            allLocations.append(dbLocation)
        }

        return allLocations
    }

    // MARK: - Private Functions

    private func loadAllLocationsFromDB() -> [Location]? {
//        let predicate = #Predicate<Location> { $0.id > 0 }
//        let descriptor = FetchDescriptor<Location>(predicate: predicate)
//
//        do {
//            return try context.fetch(descriptor)
//        }
//        catch {
//            // TODO: Error handling
//            return nil
//        }
        nil
    }

    private func loadLocationFromDB(id: Int) -> Location? {
//        let predicate = #Predicate<Location> { $0.id == id }
//        let descriptor = FetchDescriptor<Location>(predicate: predicate)
//
//        do {
//            return try context.fetch(descriptor).first
//        }
//        catch {
//            // TODO: Error handling
//            return nil
//        }
        nil
    }

    private func loadAllLocationsFromAPI() async -> [Location]? {
        do {
            return try await GfroerliBackend().load(fetchType: .allLocations)
        }
        catch {
            // TODO: Error handling
            return nil
        }
    }

    private func loadLocationFromAPI(id: Int) async -> Location? {
        do {
            return try await GfroerliBackend().load(fetchType: .singleLocation(id: id))
        }
        catch {
            // TODO: Error handling
            return nil
        }
    }

    private func persistAndAssign(_ location: Location) {
        guard useCache else {
            return
        }
        
        do {
            // context.insert(location)
            try context.save()
        }
        catch {
            // TODO: Error handling
            fatalError(error.localizedDescription)
        }
    }
}
