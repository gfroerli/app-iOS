//
//  LocationViewModel.swift
//
//  Created by Marc Kramer on 13.06.22.
//

import Foundation
import GfroerliBackend
import MapKit
import SwiftUI

@MainActor
class AllLocationsViewModel: ObservableObject {
    
    @Published var allLocations = [Location]()
    @Published var activeLocations = [Location]()
    @Published var sortedLocations = [Location]()

    @Published var sortedBy = SortVariants.mostRecent {
        didSet {
            sortLocations()
        }
    }
    
    @Published var mapRegionAll: MKCoordinateRegion = AppConfiguration.MapPreviewView.defaultRegion
    @Published var mapRegionActive: MKCoordinateRegion = AppConfiguration.MapPreviewView.defaultRegion

    // MARK: - Sorting
    
    public enum SortVariants: CaseIterable, Identifiable {
        case alphabet
        case lowest
        case highest
        case mostRecent

        public var id: SortVariants { self }
        
        public var text: LocalizedStringKey {
            switch self {
            case .mostRecent:
                return "search_view_sort_recent"

            case .highest:
                return "search_view_sort_highest"

            case .lowest:
                return "search_view_sort_lowest"

            case .alphabet:
                return "search_view_sort_alphabetical"
            }
        }
        
        public var symbolName: String {
            switch self {
            case .mostRecent:
                return "clock"

            case .highest:
                return "thermometer.sun.fill"

            case .lowest:
                return "thermometer.snowflake"

            case .alphabet:
                return "abc"
            }
        }
    }
    
    // MARK: - Public Functions
    
    public func loadAllLocations() async throws {
        guard let fetchedLocations: [Location] = try? await GfroerliBackend().load(fetchType: .allLocations) else {
            // TODO: Error handling
            return
        }

        let tempActiveLocations = fetchedLocations.filter { location in
            location.isActive
        }
        mapRegionActive = calculateMapRegion(for: tempActiveLocations)
        activeLocations = tempActiveLocations
        
        allLocations = fetchedLocations
        mapRegionAll = calculateMapRegion(for: allLocations)
        
        sortLocations()
    }
    
    // MARK: - Private Functions
    
    public func sortLocations(query: String? = nil) {
        
        var tempLocations = allLocations
        
        if let query, query != "" {
            tempLocations.removeAll { !($0.name.lowercased().contains(query.lowercased())) }
        }
        
        switch sortedBy {
        case .mostRecent:
            sortedLocations = tempLocations.sorted {
                $0.lastTemperatureDate > $1.lastTemperatureDate
            }
        case .highest:
            sortedLocations = tempLocations.sorted {
                $0.latestTemperature ?? 0.0 > $1.latestTemperature ?? 0.0
            }
        case .lowest:
            sortedLocations = tempLocations.sorted {
                $0.latestTemperature ?? 0.0 < $1.latestTemperature ?? 0.0
            }
        case .alphabet:
            sortedLocations = tempLocations.sorted {
                $0.name < $1.name
            }
        }
    }
    
    private func calculateMapRegion(for locations: [Location]) -> MKCoordinateRegion {
        
        var maxLat = -90.0
        var minLat = 90.0
        var maxLong = -180.0
        var minLong = 180.0
        
        for location in locations {
            guard let coords = location.coordinates?.coordinate else {
                continue
            }

            if coords.latitude > maxLat {
                maxLat = coords.latitude
            }
            if coords.latitude < minLat {
                minLat = coords.latitude
            }
            if coords.longitude > maxLong {
                maxLong = coords.longitude
            }
            if coords.longitude < minLong {
                minLong = coords.longitude
            }
        }
        
        let minLoc = CLLocation(latitude: minLat, longitude: minLong)
        let maxLoc = CLLocation(latitude: maxLat, longitude: maxLong)
        
        let zoom = minLoc.distance(from: maxLoc) * 1.1
        
        let centreLat = (maxLat + minLat) * 0.5
        let centreLong = (maxLong + minLong) * 0.5
        let centre = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
        
        return MKCoordinateRegion(center: centre, latitudinalMeters: zoom, longitudinalMeters: zoom)
    }
}
