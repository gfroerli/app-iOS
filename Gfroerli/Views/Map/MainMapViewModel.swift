//
//  MainMapViewModel.swift
//  Gfroerli
//
//  Created by Marc on 23.12.2025.
//

import ClusterMap
import CoreLocation
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
        case favorites

        var id: Self { self }

        var title: LocalizedStringKey {
            switch self {
            case .all:
                "main_view_filter_all"
            case .active:
                "main_view_filter_active"
            case .favorites:
                "main_view_filter_favorites"
            }
        }

        var imageName: String {
            switch self {
            case .all:
                "thermometer.medium"
            case .active:
                "thermometer.medium.slash"
            case .favorites:
                "star.fill"
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

    /// The user's most recent location, or `nil` while unknown or unauthorized.
    private(set) var userLocation: CLLocation? {
        didSet {
            frameOnUserAndClosestLocations()
        }
    }

    /// `true` once the user denied location access, so we keep the default framing.
    private(set) var locationAuthorizationDenied = false

    var currentRegion: MKCoordinateRegion = AppConfiguration.MapView.defaultRegion {
        didSet {
            withAnimation {
                expandAnnotations = currentRegion.span.latitudeDelta <= 0.1
            }
        }
    }
    
    // MARK: - Private properties

    @ObservationIgnored
    private let allLocationsManager: BusinessAllLocationsManagerProtocol

    @ObservationIgnored
    private let clusterManager = ClusterManager<MapLocation>(
        configuration: .init(
            // Position the cluster bubble at the centroid of its members so it visually sits among
            // the locations it represents, instead of at the grid-cell centre.
            clusterPosition: .average,
            // Shrink the grid cells versus the library defaults (88 pt at low zoom). Smaller cells
            // mean each cluster spans a smaller area, so far-apart locations no longer merge when
            // the whole country is visible.
            cellSizeForZoomLevel: { zoom in
                switch zoom {
                case ...9: CGSize(width: 60, height: 60)
                case 10...12: CGSize(width: 64, height: 64)
                case 13...15: CGSize(width: 56, height: 56)
                case 16...18: CGSize(width: 44, height: 44)
                default: CGSize(width: 32, height: 32)
                }
            }
        )
    )

    @ObservationIgnored
    private let userLocationProvider: UserLocationProviding

    @ObservationIgnored
    private var locationTask: Task<Void, Never>?

    /// Ensures we only auto-frame around the user once, so later location fixes don't
    /// fight the user's manual panning and zooming.
    @ObservationIgnored
    private var didInitialUserFraming = false

    // MARK: - Lifecycle

    init(
        allLocationsManager: BusinessAllLocationsManagerProtocol = AppDependencies.makeAllLocationsManager(),
        userLocationProvider: UserLocationProviding = AppDependencies.makeUserLocationProvider()
    ) {
        self.allLocationsManager = allLocationsManager
        self.userLocationProvider = userLocationProvider
        Task {
            try? await self.loadLocations()
        }
    }

    // MARK: - Public functions

    func loadLocations() async throws {
        Task.detached {
            let fetched = try await self.allLocationsManager.loadAllLocations()
            Task { @MainActor in
                self.allLocations = fetched
            }
        }
    }

    /// Starts observing the user's location. Prompts for When-In-Use authorization on first call.
    func requestUserLocation() {
        guard locationTask == nil else {
            return
        }
        locationTask = Task { [weak self] in
            guard let events = self?.userLocationProvider.events() else {
                return
            }
            for await event in events {
                switch event {
                case let .update(location):
                    self?.userLocation = location
                case .denied:
                    self?.locationAuthorizationDenied = true
                }
            }
        }
    }
    
    // MARK: - Filtering
    
    func updateFilteredLocations(repositionCamera: Bool = true) {
        switch currentFilter {
        case .all:
            filteredLocations = allLocations
        case .active:
            filteredLocations = allLocations.filter(\.isActive)
        case .favorites:
            let favorites = Set(favoriteIDs)
            filteredLocations = allLocations.filter { favorites.contains($0.id) }
        }

        if repositionCamera {
            updatePosition()
            frameOnUserAndClosestLocations()
        }
    }

    /// Re-applies the favorites filter when the favorites change elsewhere (e.g. the detail view),
    /// updating the annotations without moving the camera.
    func refreshFavoritesFilterIfNeeded() {
        guard currentFilter == .favorites else {
            return
        }
        updateFilteredLocations(repositionCamera: false)
    }

    /// The favorited location IDs, read from the same `UserDefaults` store the rest of the app
    /// uses via `@AppStorage("favorites")`.
    private var favoriteIDs: [Int] {
        guard let rawValue = UserDefaults.standard.string(forKey: "favorites"),
              let ids = [Int](rawValue: rawValue) else {
            return []
        }
        return ids
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
    
    private func updatePosition() {
        currentRegion.span = MKCoordinateSpan(
            latitudeDelta: currentRegion.span.latitudeDelta + 0.5,
            longitudeDelta: currentRegion.span.longitudeDelta + 0.5
        )
        position = .region(currentRegion)
    }

    // MARK: - User location framing

    /// Whether the map has enough information to frame around the user.
    var canFocusOnUserLocation: Bool {
        userLocation != nil && !filteredLocations.isEmpty
    }

    /// Frames the map around the user and the three closest locations. Runs once automatically,
    /// only when the user's location is known and locations have loaded. Otherwise the default
    /// framing is kept.
    private func frameOnUserAndClosestLocations() {
        guard !didInitialUserFraming, canFocusOnUserLocation else {
            return
        }
        didInitialUserFraming = true
        focusOnUserAndClosestLocations()
    }

    /// Frames the map around the user and the three closest locations. Invoked by the locate
    /// button, so it re-frames every time regardless of the one-shot auto-framing.
    func focusOnUserAndClosestLocations() {
        guard let userLocation, !filteredLocations.isEmpty else {
            return
        }

        let closest = filteredLocations
            .sorted { lhs, rhs in
                let lhsDistance = userLocation
                    .distance(from: CLLocation(latitude: lhs.latitude, longitude: lhs.longitude))
                let rhsDistance = userLocation
                    .distance(from: CLLocation(latitude: rhs.latitude, longitude: rhs.longitude))
                return lhsDistance < rhsDistance
            }
            .prefix(3)

        var coordinates = closest
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        coordinates.append(userLocation.coordinate)

        let region = Self.region(enclosing: coordinates)
        withAnimation {
            position = .region(region)
        }
    }

    // MARK: - Cluster zooming

    /// Zooms the map to reveal the contents of a tapped cluster. Frames the cluster's member
    /// locations directly (instead of a fixed zoom level) so tapping always breaks the cluster
    /// apart. Guarantees a visible change even when the fitted region wouldn't zoom in.
    func zoom(into cluster: MapLocationCluster) {
        let coordinates = cluster.locations.map(\.coordinate)
        guard !coordinates.isEmpty else {
            return
        }

        var region = Self.region(enclosing: coordinates, paddingFactor: 1.4, minimumSpan: 0.01)

        // If fitting the members wouldn't actually zoom in (e.g. a wide-spread cluster, or a
        // repeated tap), step in on the cluster centre so the camera always moves.
        if region.span.latitudeDelta >= currentRegion.span.latitudeDelta {
            region = MKCoordinateRegion(
                center: cluster.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: currentRegion.span.latitudeDelta / 3,
                    longitudeDelta: currentRegion.span.longitudeDelta / 3
                )
            )
        }

        withAnimation {
            position = .region(region)
        }
    }

    /// Builds a region that encloses all of the given coordinates, with padding around the edges.
    private static func region(
        enclosing coordinates: [CLLocationCoordinate2D],
        paddingFactor: Double = 2.2,
        minimumSpan: Double = 0.08
    ) -> MKCoordinateRegion {
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        guard let minLatitude = latitudes.min(), let maxLatitude = latitudes.max(),
              let minLongitude = longitudes.min(), let maxLongitude = longitudes.max() else {
            return AppConfiguration.MapView.defaultRegion
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )

        // Pad the bounding box so annotations aren't flush against the edges (annotation views
        // have height and need headroom), and enforce a minimum span so a tightly clustered set
        // doesn't zoom in excessively.
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLatitude - minLatitude) * paddingFactor, minimumSpan),
            longitudeDelta: max((maxLongitude - minLongitude) * paddingFactor, minimumSpan)
        )

        return MKCoordinateRegion(center: center, span: span)
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
