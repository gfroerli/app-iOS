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
    
    @Published var averageTemp = 15.0
    
    @Published var hasDataPoints = false
    
    @Published var zoomedYAxisMinValue = 0
    
    @Published var zoomedYAxisMaxValue = 30
    
    @Published var xAxisLabel = ""

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
                await insertMeasurements(measurements)
                await createPlaceholderMeasurements()
                await calculateYAxisZoomedValues()
                await updateXAxisLabel()
                await checkHasDataPoints()
                await calculateAvgTemp()
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
    private func insertMeasurements(_ measurements: [TemperatureMeasurementCollection]) {
        var tempMinTemps = [TemperatureMeasurement]()
        var tempAvgTemps = [TemperatureMeasurement]()
        var tempMaxTemps = [TemperatureMeasurement]()

        for measurement in measurements {
            
            switch interval {
            case .day:
                if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .day) {
                    tempMinTemps.insert(
                        TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.lowest),
                        at: 0
                    )
                    tempAvgTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.average
                        ),
                        at: 0
                    )
                    tempMaxTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.highest
                        ),
                        at: 0
                    )
                }
            case .week:
                if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .weekOfYear) {
                    tempMinTemps.insert(
                        TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.lowest),
                        at: 0
                    )
                    tempAvgTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.average
                        ),
                        at: 0
                    )
                    tempMaxTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.highest
                        ),
                        at: 0
                    )
                }
            case .month:
                
                if measurement.measurementDate.isEqual(to: currentDate, toGranularity: .month) {
                    tempMinTemps.insert(
                        TemperatureMeasurement(measurementDate: measurement.measurementDate, value: measurement.lowest),
                        at: 0
                    )
                    tempAvgTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.average
                        ),
                        at: 0
                    )
                    tempMaxTemps.insert(
                        TemperatureMeasurement(
                            measurementDate: measurement.measurementDate,
                            value: measurement.highest
                        ),
                        at: 0
                    )
                }
            }
        }
        
        lowestTemperatures = tempMinTemps
        averageTemperatures = tempAvgTemps
        highestTemperatures = tempMaxTemps
    }
    
    @MainActor
    private func checkHasDataPoints() {
        if !lowestTemperatures.isEmpty || !averageTemperatures.isEmpty || !highestTemperatures.isEmpty {
            hasDataPoints = true
        }
        else {
            hasDataPoints = false
        }
    }
    
    @MainActor
    private func calculateAvgTemp() {
        guard !averageTemperatures.isEmpty else {
            averageTemp = 15.0
            return
        }
        
        let sum = averageTemperatures.reduce(0) { $0 + $1.value }
        averageTemp = sum / Double(averageTemperatures.count)
    }
    
    @MainActor
    private func calculateYAxisZoomedValues() {
        zoomedYAxisMinValue = Int((lowestTemperatures.min { $0.value < $1.value }?.value ?? 0.0).rounded(.down))
        zoomedYAxisMaxValue = Int((highestTemperatures.max { $0.value < $1.value }?.value ?? 30.0).rounded(.up))
    }
    
    @MainActor
    private func updateXAxisLabel() {
        switch interval {
        case .day:
            xAxisLabel = currentDate.formatted(.dateTime.day().month(.wide).year())
        case .week:
            xAxisLabel = currentDate.formatted(.dateTime.day().month()) + " - " + Calendar.current
                .date(byAdding: .day, value: 7, to: currentDate)!.formatted(.dateTime.day().month().year())
        case .month:
            xAxisLabel = currentDate.formatted(.dateTime.month(.wide).year())
        }
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
