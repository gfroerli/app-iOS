//
//  UserLocationService.swift
//  Gfroerli
//
//  Supplies the user's current location to the map. Abstracted behind a protocol so the map
//  view model can be driven with deterministic fixtures during screenshot capture and previews.
//

import CoreLocation
import Foundation

/// A single event emitted while observing the user's location.
enum UserLocationEvent: Sendable {
    /// A new location fix became available.
    case update(CLLocation)
    /// The user denied (or restricted) location access. Callers should fall back gracefully.
    case denied
}

/// Source of user-location events. Conformers vend an async stream that emits fixes and
/// authorization changes.
protocol UserLocationProviding: Sendable {
    /// Returns a stream of location events. Iterating the stream prompts the user for
    /// When-In-Use authorization when the current status is not yet determined.
    func events() -> AsyncStream<UserLocationEvent>
}

/// Live implementation backed by Core Location's modern async update stream.
struct LiveUserLocationProvider: UserLocationProviding {

    func events() -> AsyncStream<UserLocationEvent> {
        AsyncStream { continuation in
            let task = Task {
                do {
                    // Iterating `liveUpdates()` triggers the authorization prompt when needed.
                    for try await update in CLLocationUpdate.liveUpdates() {
                        if let location = update.location {
                            continuation.yield(.update(location))
                        }
                        else if update.authorizationDenied {
                            continuation.yield(.denied)
                        }
                    }
                }
                catch {
                    // Streaming failed; leave the map on its default framing.
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

/// No-op provider used for screenshots and previews. Emits nothing, so the map keeps its
/// existing default framing and no authorization prompt is shown.
struct EmptyUserLocationProvider: UserLocationProviding {

    func events() -> AsyncStream<UserLocationEvent> {
        AsyncStream { continuation in
            continuation.finish()
        }
    }
}
