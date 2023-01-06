//
//  HourlyTemperaturesViewModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import Foundation
import GfroerliAPI

class HourlyTemperaturesViewModel: ObservableObject {
    
    /// Used to make the graph full width even when we do not have measurements in all time slots
    public var placeholderTemperatures = [TemperatureMeasurement]()
    /// Used to disable the forward button
    public var isAtCurrentDate: Bool {
        Calendar.current.isDate(initialDate, inSameDayAs: currentDate)
    }
    
    private var id: Int
    private var initialDate: Date
    private var currentDate: Date
    
    // MARK: - Lifecycle
    
    init(locationID: Int, date: Date) {
        self.id = locationID
        self.initialDate = date
        self.currentDate = date
        
        createPlaceholderMeasurements()
        loadHourlyMeasurements()
    }
   
    // MARK: - Published Properties

    @Published var lowestTemperatures = [TemperatureMeasurement]()
    
    @Published var averageTemperatures = [TemperatureMeasurement]()
    
    @Published var highestTemperatures = [TemperatureMeasurement]()
    
    // MARK: - Public Functions
    
    /// Steps a day back and loads measurements
    public func stepDayBack() {
        Task {
            await removeMeasurements()
            currentDate = currentDate.advanced(by: -AppConfiguration.CommonTimeInterval.day)
            createPlaceholderMeasurements()
            loadHourlyMeasurements()
        }
    }
    
    /// Steps a day forward and loads measurements
    public func stepDayForward() {
        Task {
            await removeMeasurements()
            currentDate = currentDate.advanced(by: AppConfiguration.CommonTimeInterval.day)
            createPlaceholderMeasurements()
            loadHourlyMeasurements()
        }
    }
    
    // MARK: - Private Functions

    private func loadHourlyMeasurements() {
        Task {
            guard let measurements: [TemperatureMeasurementCollection] = try? await GfroerliAPI()
                .load(fetchType: .hourlyTemperatures(
                    locationID: id,
                    of: currentDate
                )) else {
                return
            }
            
            for measurement in measurements {
                if Calendar.current.isDate(measurement.measurementDate, inSameDayAs: currentDate) {
                    Task {
                        await insertMeasurement(measurement)
                    }
                }
            }
        }
    }
    
    @MainActor
    private func removeMeasurements() {
        lowestTemperatures.removeAll()
        averageTemperatures.removeAll()
        highestTemperatures.removeAll()
    }
    
    @MainActor
    private func insertMeasurement(_ measurement: TemperatureMeasurementCollection) {
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

    private func createPlaceholderMeasurements() {
        placeholderTemperatures.removeAll()
        
        let midnightComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
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
