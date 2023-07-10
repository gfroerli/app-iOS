//
//  SingleLocationViewModel.swift
//
//
//  Created by Marc on 08.06.2023.
//

import Foundation
import Observation
import SwiftData

/// ViewModel handling CRUD for single `Location`
@MainActor
@Observable public class SingleLocationViewModel {
    // MARK: - Public Properties

    // swiftformat:disable:next all
    public var location: Location? = nil

    // MARK: - Private Properties

    private let context = GfroerliBackend.modelContainer.mainContext
    private let id: Int

    // MARK: - Lifecycle

    /// Initializer
    /// - Parameter id: ID of the `Location` to be loaded
    public init(id: Int) {
        self.id = id

        Task {
            self.location = await LocationManager.shared.location(for: id)
        }
    }

    // MARK: - Public Functions

    /// Updates the local `Location`, if set, with freshly fetched data from the server
    public func refreshLocation() async {
        guard var location else {
            // TODO: Error handling
            return
        }
        await LocationManager.shared.refreshLocation(location: &location)
    }

    public func getID() -> Int {
        id
    }
}
