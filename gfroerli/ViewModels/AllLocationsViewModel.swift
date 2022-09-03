//
//  LocationViewModel.swift
//
//  Created by Marc Kramer on 13.06.22.
//

import Foundation
import GfroerliAPI
import MapKit

@MainActor
class AllLocationsViewModel: ObservableObject {
    
    @Published var allLocations: [Location] = [Location]()
    @Published var activeLocations: [Location] = [Location]()
    @Published var mapRegionAll: MKCoordinateRegion = AppConfiguration.MapPreviewView.defaultRegion
    @Published var mapRegionActive: MKCoordinateRegion = AppConfiguration.MapPreviewView.defaultRegion

    // MARK: - Public Functions
    
    public func loadAllLocations() async throws {
        guard let fetchedLocations: [Location] = try? await GfroerliAPI().load(fetchType: .allLocations) else {
            // TODO: Error handling
            fatalError("")
        }
        allLocations = fetchedLocations
        activeLocations = fetchedLocations.filter({ location in
            guard let lastTempDate = location.lastTemperatureDate else {
                return false
            }
            return DateUtil.wasInLast72Hours(givenDate: lastTempDate)
        })
        
        mapRegionAll = calculateMapRegion(for: allLocations)
        mapRegionActive = calculateMapRegion(for: activeLocations)
    }
    
    // MARK: - Private Functions
    
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
        
        let zoom = minLoc.distance(from: maxLoc)
        
        let centreLat = (maxLat + minLat) * 0.5
        let centreLong = (maxLong + minLong) * 0.5
        let centre = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
        
        return MKCoordinateRegion(center: centre, latitudinalMeters: zoom, longitudinalMeters: zoom)
    }
}
