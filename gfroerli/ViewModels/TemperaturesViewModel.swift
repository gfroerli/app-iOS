//
//  HourlyTemperaturesViewModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import Charts
import Foundation
import GfroerliAPI

enum ChartSpan {
    case day
    case week
    case month
}

class TemperaturesViewModel: ObservableObject {
    
    /// Used to make the graph full width even when we do not have measurements in all time slots
    public var placeholderTemperatures = [TemperatureMeasurement]()
   
    /// Used to disable the forward button
    public var isAtMostRecentInterval: Bool {
        var isAtMostRecentInterval: Bool!
        
        switch interval {
        case .day:
            isAtMostRecentInterval = Calendar.current.isDate(initialDate, inSameDayAs: currentDate)
        case .week:
            isAtMostRecentInterval = initialDate.isEqual(to: currentDate, toGranularity: .weekOfYear)
        case .month:
            isAtMostRecentInterval = initialDate.isEqual(to: currentDate, toGranularity: .month)
        }
        return isAtMostRecentInterval
    }
    
    private var id: Int
    private var interval: ChartSpan
    private var initialDate: Date
    
    // MARK: - Lifecycle
    
    init(locationID: Int, interval: ChartSpan, date: Date) {
        self.id = locationID
        self.initialDate = date
        self.interval = interval
        
        switch interval {
        case .day:
            self.currentDate = date
        case .week:
            self.currentDate = date.firstDayOfTheSameWeek
        case .month:
            self.currentDate = date.startOfMonth
        }
        
        loadMeasurements()
    }
   
    // MARK: - Published Properties

    @Published var currentDate: Date

    @Published var lowestTemperatures = [TemperatureMeasurement]()
    
    @Published var averageTemperatures = [TemperatureMeasurement]()
    
    @Published var highestTemperatures = [TemperatureMeasurement]()
    
    @Published var zoomedYAxisMinValue = 0
    
    @Published var zoomedYAxisMaxValue = 30

    // MARK: - Public Functions
    
    /// Steps back and loads measurements
    public func stepBack() {
        Task {
            await removeMeasurements()
            await reduceCurrentDate()
            loadMeasurements()
        }
    }
    
    /// Steps forward and loads measurements
    public func stepForward() {
        Task {
            await removeMeasurements()
            await advanceCurrentDate()
            loadMeasurements()
        }
    }
    
    // MARK: - Private Functions

    private func loadMeasurements() {
        Task {
            
            var fetchType: FetchType!
            
            // Create FetchType to fetch
            switch interval {
            case .day:
                fetchType = .hourlyTemperatures(locationID: id, of: currentDate)
            case .week:
                fetchType = .dailyTemperatures(
                    locationID: id,
                    from: currentDate,
                    to: Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                )
            case .month:
                fetchType = .dailyTemperatures(
                    locationID: id,
                    from: currentDate,
                    to: Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
                )
            }
            
            // Fetch
            guard let measurements: [TemperatureMeasurementCollection] = try? await GfroerliAPI()
                .load(fetchType: fetchType) else {
                return
            }
            Task {
                // Assign fetched changes
                for measurement in measurements {
                    switch interval {
                    case .day:
                        if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .day) {
                            await insertMeasurement(measurement)
                        }
                    case .week:
                        if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .weekOfYear) {
                            await insertMeasurement(measurement)
                        }
                    case .month:
                        
                        if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .month) {
                            await insertMeasurement(measurement)
                        }
                    }
                }
                await createPlaceholderMeasurements()
                await calculateYAxisZoomedValues()
            }
        }
    }
  
    @MainActor
    private func advanceCurrentDate() {
        switch interval {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate.firstDayOfTheSameWeek)!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate.startOfMonth)!
        }
    }
    
    @MainActor
    private func reduceCurrentDate() {
        switch interval {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate.firstDayOfTheSameWeek)!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate.startOfMonth)!
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
        print(measurement.measurementDate.description(with: .current))
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
    
    @MainActor
    private func calculateYAxisZoomedValues() {
        zoomedYAxisMinValue = Int((lowestTemperatures.min { $0.value < $1.value }?.value ?? 0.0).rounded(.down))
        zoomedYAxisMaxValue = Int((highestTemperatures.max { $0.value < $1.value }?.value ?? 30.0).rounded(.up))
    }

    @MainActor
    private func createPlaceholderMeasurements() {
        
        placeholderTemperatures.removeAll()
        var placeholders = [TemperatureMeasurement]()
        
        var rangeMax: Int!
        
        switch interval {
        case .day:
            rangeMax = 23
        case .week:
            rangeMax = 6
        case .month:
            rangeMax = (Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 30) - 1
        }
        
        switch interval {
        case .day:
            let midnightComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
            let midnightDate = Calendar.current.date(from: midnightComponents)!
            for i in 0...rangeMax {
                placeholders
                    .append(TemperatureMeasurement(
                        measurementDate: Calendar.current.date(byAdding: .hour, value: i, to: midnightDate)!,
                        value: averageTemperatures.first?.value ?? 0.0
                    ))
            }
                
        case .week, .month:
            for i in 0...rangeMax {
                placeholders
                    .append(TemperatureMeasurement(
                        measurementDate: Calendar.current.date(byAdding: .day, value: i, to: currentDate)!,
                        value: averageTemperatures.first?.value ?? 0.0
                    ))
            }
        }
        
        placeholderTemperatures = placeholders
    }
}
