//
//  SponsorViewModel.swift
//
//
//  Created by Marc on 08.06.2023.
//

import Foundation

import Foundation
import Observation
import SwiftData
import SwiftUI

/// ViewModel handling CRUD for `Sponsor`
@MainActor
@Observable public class SponsorViewModel {
    // MARK: - Lifecycle

    /// Initializer
    /// - Parameter id: ID of the Sponsor to be loaded
    public init(id: Int) {
        self.id = id

        Task {
            await loadSponsor()
        }
    }

    // MARK: - Public Properties

    // swiftformat:disable:next all
    public var sponsor: Sponsor? = nil

    // MARK: - Private Properties

    private let context = GfroerliBackend.modelContainer.mainContext
    private let id: Int

    private let useCache = UserDefaults.standard.bool(forKey: "UseCache")

    // MARK: - Public Functions

    /// Loads the Sponsor with the ID the ViewModel was initialized with
    public func loadSponsor() async {
        // Try to load from SwiftData
        if useCache, let dbSponsor = loadFromDB() {
            sponsor = dbSponsor
            // TODO: Outdated
            return
        }

        // If non-existent in SwiftData or outdated, we load from API
        if let apiSponsor = await loadFromAPI() {
            persistAndAssign(apiSponsor)
        }
    }

    // MARK: - Private Functions

    private func loadFromDB() -> Sponsor? {
        let predicate = #Predicate<Sponsor> { $0.id == id }
        let descriptor = FetchDescriptor<Sponsor>(predicate: predicate)

        do {
            return try context.fetch(descriptor).first
        }
        catch {
            // TODO: Error handling
            return nil
        }
    }

    private func loadFromAPI() async -> Sponsor? {
        do {
            return try await GfroerliBackend().load(fetchType: .sponsor(id: id))
        }
        catch {
            // TODO: Error handling
            return nil
        }
    }

    private func persistAndAssign(_ apiSponsor: Sponsor) {
        do {
            sponsor = apiSponsor
            
            if useCache {
                context.insert(sponsor!)
                try context.save()
            }
        }
        catch {
            // TODO: Error handling
        }
    }
}
