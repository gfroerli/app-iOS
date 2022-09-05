//
//  HourlyTemperaturesViewModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import Foundation
import GfroerliAPI

@MainActor
class HourlyTemperaturesViewModel: ObservableObject {
    @Published var hourlyMeasurements = [TemperatureMeasurement]()

    public func loadHourlyMeasurements(locationID: Int) async throws {
        guard let measurements: [TemperatureMeasurement] = try? await GfroerliAPI()
            .load(fetchType: .hourlyTemperatures(
                locationID: locationID,
                from: Date.now.addingTimeInterval(-86000),
                to: Date.now
            )) else {
            fatalError("")
        }
        hourlyMeasurements = measurements
    }
}
