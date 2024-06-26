//
//  LocationViewModel.swift
//
//  Created by Marc Kramer on 10.06.2023.
//

import Foundation
import Observation
import SwiftData
import WidgetKit

@MainActor
@Observable public class AllLocationsViewModel {
    // MARK: - Public Properties

    // swiftformat:disable:next all
    public var allLocations = [Location]()
    public var activeLocations = [Location]()
    public var filteredLocations = [Location]()
    public var sortedLocations = [Location]()
    public var sortedVariant: SortVariants = .mostRecent
    public var isFilterActive = true {
        didSet {
            filterChanged()
        }
    }
    
    // MARK: - Private Properties

    private let context = GfroerliBackend.modelContainer.mainContext

    // MARK: - Lifecycle

    public init() {
        Task {
            await loadAllLocations()
        }
    }

    // MARK: - Public Functions

    public func loadAllLocations() async {
        guard let locations = await LocationManager.shared.loadAllLocations() else {
            return
        }

        allLocations = locations
        activeLocations = locations.filter { $0.isActive }
        sortLocations(query: "")
        filterChanged()
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func sortLocations(query: String? = nil) {
        var tempLocations = allLocations

        if let query, query != "" {
            tempLocations.removeAll { !($0.name!.lowercased().contains(query.lowercased())) }
        }

        switch sortedVariant {
        case .mostRecent:
            sortedLocations = tempLocations.sorted {
                $0.lastTemperatureDate! > $1.lastTemperatureDate!
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
                $0.name! < $1.name!
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func filterChanged() {
        if isFilterActive {
            filteredLocations = activeLocations
        }
        else {
            filteredLocations = allLocations
        }
    }
}
