//
//  MainMapViewModel.swift
//  Gfroerli
//
//  Created by Marc on 23.12.2025.
//

import ClusterMap
import Foundation
import GfroerliBusiness
import GfroerliBusinessProtocols
import MapKit
import Observation
import SwiftUI

@Observable
@MainActor
final class MainMapViewModel {
    
    // MARK: - Types
    
    enum MapFilter: Int, CaseIterable, Identifiable {
        case all
        case active
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            switch self {
            case .all:
                "main_view_filter_all"
            case .active:
                "main_view_filter_active"
            }
        }
        
        var imageName: String {
            switch self {
            case .all:
                "thermometer.medium"
            case .active:
                "thermometer.medium.slash"
            }
        }
    }
    
    // MARK: - Observed properties

    var selectedLocation: MapLocation?
    var currentFilter: MapFilter = .active {
        didSet {
            updateFilteredLocations()
        }
    }
    
    /// Locations that were loaded from backend
    private(set) var allLocations = [BusinessLocationProtocol]() {
        didSet {
            updateFilteredLocations()
            searchResultLocations = allLocations
        }
    }

    /// Locations that included in the currently selected filter option
    private(set) var filteredLocations = [BusinessLocationProtocol]() {
        didSet {
            updateAnnotations()
        }
    }
    
    private(set) var searchResultLocations = [BusinessLocationProtocol]()
    
    // Map
    var annotations: [MapLocation] = []
    var clusters: [MapLocationCluster] = []
    var expandAnnotations = false

    var mapSize: CGSize = .zero
    var position: MapCameraPosition = .automatic

    var currentRegion: MKCoordinateRegion = AppConfiguration.MapView.defaultRegion {
        didSet {
            withAnimation {
                expandAnnotations = currentRegion.span.latitudeDelta <= 0.1
            }
        }
    }
    
    // MARK: - Private properties

    @ObservationIgnored
    private let allLocationsManager = BusinessAllLocationsManager()
    
    @ObservationIgnored
    private let clusterManager = ClusterManager<MapLocation>()
    
    // MARK: - Lifecycle
    
    init() { }
    
    // MARK: - Public functions
    
    func loadLocations() async throws {
        Task.detached {
            let fetched = try await self.allLocationsManager.loadAllLocations()
            Task { @MainActor in
                self.allLocations = fetched
            }
        }
    }
    
    // MARK: - Filtering
    
    func updateFilteredLocations() {
        switch currentFilter {
        case .all:
            filteredLocations = allLocations
        case .active:
            filteredLocations = allLocations.filter(\.isActive)
        }
    }
    
    // MARK: - Searching
    
    func updateSearchLocations(for query: String) {
        searchResultLocations = allLocations
            .filter {
                $0.name.folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
                    .contains(query.lowercased())
            }
    }
    
    // MARK: - Map / Annotations
    
    func updateAnnotations() {
        let newAnnotations = filteredLocations
            .map {
                MapLocation(
                    id: $0.id,
                    coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                    name: $0.name,
                    lastTemperatureString: $0.lastTemperatureString,
                    isActive: $0.isActive
                )
            }
        Task { @MainActor in
            await self.clusterManager.removeAll()
            await self.clusterManager.add(newAnnotations)
            await self.reloadAnnotations()
        }
    }
    
    func removeAnnotations() async {
        await clusterManager.removeAll()
        await reloadAnnotations()
    }

    func reloadAnnotations() async {
        async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
        await applyChanges(changes)
    }
    
    @MainActor
    private func applyChanges(_ difference: ClusterManager<MapLocation>.Difference) {
        for removal in difference.removals {
            switch removal {
            case let .annotation(annotation):
                annotations.removeAll { $0 == annotation }
            case let .cluster(clusterAnnotation):
                clusters.removeAll { $0.id == clusterAnnotation.id }
            }
        }
        
        for insertion in difference.insertions {
            switch insertion {
            case let .annotation(newItem):
                annotations.append(newItem)
            case let .cluster(newItem):
                clusters.append(MapLocationCluster(
                    id: newItem.id,
                    coordinate: newItem.coordinate,
                    locations: newItem.memberAnnotations
                ))
            }
        }
    }
}

struct MapLocation: CoordinateIdentifiable, Identifiable, Hashable {
    var id: Int
    var coordinate: CLLocationCoordinate2D
    var name: String
    var lastTemperatureString: String
    var isActive: Bool
}

struct MapLocationCluster: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var locations: [MapLocation]
}
