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
   
    @Published var lowestTemperatures = [TemperatureMeasurement]()
    @Published var averageTemperatures = [TemperatureMeasurement]()
    @Published var highestTemperatures = [TemperatureMeasurement]()
    @Published var placeholderTemperatures = [TemperatureMeasurement]()
    
    // MARK: - Public Functions

    public func loadHourlyMeasurements(locationID: Int, of date: Date) async throws {
        guard let measurements: [TemperatureMeasurementCollection] = try? await GfroerliAPI()
            .load(fetchType: .hourlyTemperatures(
                locationID: locationID,
                of: date
            )) else {
            return
        }
                
        for measurement in measurements {
            if Calendar.current.isDate(measurement.measurementDate, inSameDayAs: date) {
                lowestTemperatures.insert(
                    TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.lowest),
                    at: 0
                )
                averageTemperatures.insert(
                    TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.average),
                    at: 0
                )
                highestTemperatures.insert(
                    TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.highest),
                    at: 0
                )
            }
        }
        createPlaceholderMeasurements(for: date)
    }
    
    // MARK: - Private Functions

    private func createPlaceholderMeasurements(for date: Date) {
        let midnightComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let midnightDate = Calendar.current.date(from: midnightComponents)!
        
        var placeholders = [TemperatureMeasurement]()
        for i in 0...23 {
            placeholders
                .append(TemperatureMeasurement(
                    measurementDate: midnightDate.addingTimeInterval(TimeInterval(i * 3600)),
                    value: 0.0
                ))
        }
        
        placeholderTemperatures = placeholders
    }
}
