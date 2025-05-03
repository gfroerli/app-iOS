//
//  File.swift
//
//
//  Created by Marc on 30.05.2024.
//

import Charts
import Foundation
import Observation
import SwiftUI

public enum ChartTimeSpan: Int, Equatable {
    case day
    case week
    case month
    
    // TODO: Do date handling else where
    func fetchType(for locationID: Int, date: Date) -> FetchType {
        switch self {
        case .day:
            .hourlyTemperatures(locationID: locationID, of: date)
        
        case .week:
            .dailyTemperatures(
                locationID: locationID,
                from: date,
                to: Calendar.current.date(byAdding: .day, value: 7, to: date)!
            )
        
        case .month:
            .dailyTemperatures(
                locationID: locationID,
                from: date,
                to: Calendar.current.date(byAdding: .month, value: 1, to: date)!
            )
        }
    }
    
    public var granularity: Calendar.Component {
        switch self {
        case .day:
            .day
        case .week:
            .weekOfYear
        case .month:
            .month
        }
    }
    
    public var chartXUnit: Calendar.Component {
        switch self {
        case .day:
            .hour
        case .week, .month:
            .day
        }
    }
}

public enum TemperatureSeriesType: String {
    case min, avg, max, placeholder
    
    public var chartColor: Color {
        switch self {
        case .min:
            .blue
        case .avg:
            .green
        case .max:
            .red
        case .placeholder:
            .clear
        }
    }
}

public struct TemperatureSeries: Identifiable {
    public let type: TemperatureSeriesType
    public let values: [TemperatureMeasurement]
    public var id: String { type.rawValue }
}

public struct TemperatureEntry {
    public let min: TemperatureMeasurement
    public let avg: TemperatureMeasurement
    public var max: TemperatureMeasurement
}

@MainActor
@Observable
public class TemperatureChartViewModel {
   
    public var data: (
        min: TemperatureSeries,
        avg: TemperatureSeries,
        max: TemperatureSeries,
        placeholder: TemperatureSeries
    )?
    
    public var dataArray: [TemperatureSeries] {
        guard let data else {
            return [TemperatureSeries]()
        }
        
        return [data.min, data.avg, data.max, data.placeholder]
    }
    
    public var timeSpan: ChartTimeSpan = .day {
        didSet {
            switch timeSpan {
            case .day:
                currentDate = .now
            case .week:
                currentDate = .now.firstDayOfTheSameWeek
            case .month:
                currentDate = .now.startOfMonth
            }
        }
    }
    
    public var intervalLabel: String {
        switch timeSpan {
        case .day:
            currentDate.formatted(.dateTime.day().month(.wide).year())
        case .week:
            currentDate.formatted(.dateTime.day().month()) + " - " + Calendar.current
                .date(byAdding: .day, value: 7, to: currentDate)!.formatted(.dateTime.day().month().year())
        case .month:
            currentDate.formatted(.dateTime.month(.wide).year())
        }
    }
    
    /// Used to disable the forward button
    public var isAtMostRecentInterval: Bool {
        let isAtMostRecentInterval: Bool = switch timeSpan {
        case .day:
            Calendar.current.isDate(initialDate, inSameDayAs: currentDate)
        case .week:
            initialDate.isEqual(to: currentDate, toGranularity: .weekOfYear)
        case .month:
            initialDate.isEqual(to: currentDate, toGranularity: .month)
        }
        return isAtMostRecentInterval
    }

    public var zoomed = true
    public var highestTemp: Double = 30
    public var lowestTemp: Double = 0
    
    // MARK: - Private properties

    private let locationID: Int
    private let initialDate: Date
    
    private var currentDate: Date {
        didSet {
            Task {
                await loadValues()
            }
        }
    }
    
    // MARK: - Lifecycle

    public init(locationID: Int, timeSpan: ChartTimeSpan) {
        self.locationID = locationID
        self.timeSpan = timeSpan
        
        let startDate: Date = switch timeSpan {
        case .day:
            .now
        case .week:
            .now.firstDayOfTheSameWeek
        case .month:
            .now.startOfMonth
        }
        
        self.initialDate = startDate
        self.currentDate = startDate
        
        Task {
            await loadValues()
        }
    }
    
    // MARK: - Public functions
    
    public func advanceDate() {
        switch timeSpan {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate.firstDayOfTheSameWeek)!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate.startOfMonth)!
        }
    }
    
    public func reduceDate() {
        switch timeSpan {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate.firstDayOfTheSameWeek)!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate.startOfMonth)!
        }
    }
    
    // MARK: - Private functions
    
    private func loadValues() async {
        Task {
            guard let measurements: [TemperatureMeasurementCollection] = try? await GfroerliBackend()
                .load(fetchType: timeSpan.fetchType(for: locationID, date: currentDate))
            else {
                return
            }
            insertMeasurements(measurements)
        }
    }
    
    @MainActor
    private func insertMeasurements(_ measurements: [TemperatureMeasurementCollection]) {
        var tempMinTemps = [TemperatureMeasurement]()
        var tempAvgTemps = [TemperatureMeasurement]()
        var tempMaxTemps = [TemperatureMeasurement]()
        var lowest = 100.0
        var highest: Double = -100.0
        
        for measurement in measurements {
            if measurement.measurementDate.isEqual(to: currentDate, toGranularity: timeSpan.granularity) {
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
                
                if measurement.highest > highest {
                    highest = measurement.highest
                }
                if measurement.lowest < lowest {
                    lowest = measurement.lowest
                }
            }
        }
        
        let minimums = TemperatureSeries(type: .min, values: tempMinTemps)
        let averages = TemperatureSeries(type: .avg, values: tempAvgTemps)
        let maximums = TemperatureSeries(type: .max, values: tempMaxTemps)
        let placeHolders = TemperatureSeries(type: .placeholder, values: createPlaceholderMeasurements())
        data = (minimums, averages, maximums, placeHolders)
        
        guard lowest < highest else {
            lowestTemp = 0
            highestTemp = 30
            return
        }
        
        lowestTemp = lowest.rounded(.down)
        highestTemp = highest.rounded(.up)
    }
    
    @MainActor
    private func createPlaceholderMeasurements() -> [TemperatureMeasurement] {
        var placeholders = [TemperatureMeasurement]()

        let rangeMax: Int! = switch timeSpan {
        case .day:
            23
        case .week:
            6
        case .month:
            (Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 30) - 1
        }

        switch timeSpan {
        case .day:
            let midnightComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
            let midnightDate = Calendar.current.date(from: midnightComponents)!
            for i in 0...rangeMax {
                placeholders
                    .append(TemperatureMeasurement(
                        measurementDate: Calendar.current.date(byAdding: .hour, value: i, to: midnightDate)!,
                        value: 0.0
                    ))
            }

        case .week, .month:
            for i in 0...rangeMax {
                placeholders
                    .append(TemperatureMeasurement(
                        measurementDate: Calendar.current.date(byAdding: .day, value: i, to: currentDate)!,
                        value: 0.0
                    ))
            }
        }
        return placeholders
    }
    
    public func temperatureEntry(for date: Date) -> TemperatureEntry? {
        guard let data else {
            return nil
        }
        let min = data.min.values.first {
            $0.measurementDate.isEqual(to: date, toGranularity: timeSpan.chartXUnit)
        }
        let avg = data.avg.values.first {
            $0.measurementDate.isEqual(to: date, toGranularity: timeSpan.chartXUnit)
        }
        let max = data.max.values.first {
            $0.measurementDate.isEqual(to: date, toGranularity: timeSpan.chartXUnit)
        }
        
        guard let min, let avg, let max else {
            return nil
        }
        
        return TemperatureEntry(min: min, avg: avg, max: max)
    }
}

extension Date {
    var firstDayOfTheSameWeek: Date {
        Calendar.iso8601.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)!
    }

    func isEqual(
        to date: Date,
        toGranularity component: Calendar.Component,
        in calendar: Calendar = .current
    ) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}
