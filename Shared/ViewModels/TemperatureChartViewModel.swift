//
//  TemperatureChartViewModel.swift
//  Gfroerli
//
//  Backs the temperature-history chart shared various targets

import Charts
import Foundation
import GfroerliBusiness
import GfroerliBusinessProtocols
import Observation
import SwiftUI

/// The interval the chart displays at once.
enum ChartTimeSpan: Int, Equatable {
    case day
    case week
    case month

    
    var granularity: Calendar.Component {
        switch self {
        case .day:
            .day
        case .week:
            .weekOfYear
        case .month:
            .month
        }
    }
    
    var chartXUnit: Calendar.Component {
        switch self {
        case .day:
            .hour
        case .week, .month:
            .day
        }
    }
}

/// The three temperature series plus a transparent placeholder used to force a full-width axis.
enum TemperatureSeriesType: String {
    case min, avg, max, placeholder

    var chartColor: Color {
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


struct TemperatureChartPoint: Identifiable {
    let id = UUID()
    let measurementDate: Date
    let value: Double
}

struct TemperatureSeries: Identifiable {
    let type: TemperatureSeriesType
    let values: [TemperatureChartPoint]
    var id: String { type.rawValue }
}

/// The min / avg / max readings at a single selected point, ready to display in the lollipop.
struct TemperatureEntry {
    let date: Date
    let minString: String
    let avgString: String
    let maxString: String
}

@MainActor
@Observable
final class TemperatureChartViewModel {

    // MARK: - Observed properties

    var data: (
        min: TemperatureSeries,
        avg: TemperatureSeries,
        max: TemperatureSeries,
        placeholder: TemperatureSeries
    )?

    var dataArray: [TemperatureSeries] {
        guard let data else {
            return [TemperatureSeries]()
        }
        return [data.min, data.avg, data.max, data.placeholder]
    }

    var timeSpan: ChartTimeSpan = .day {
        didSet {
            switch timeSpan {
            case .day:
                currentDate = .now
            case .week:
                currentDate = startOfWeek(.now)
            case .month:
                currentDate = startOfMonth(.now)
            }
        }
    }

    var intervalLabel: String {
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

    /// Used to disable the forward button.
    var isAtMostRecentInterval: Bool {
        switch timeSpan {
        case .day:
            Calendar.current.isDate(initialDate, inSameDayAs: currentDate)
        case .week:
            isEqual(initialDate, currentDate, .weekOfYear)
        case .month:
            isEqual(initialDate, currentDate, .month)
        }
    }

    var zoomed = true
    var highestTemp: Double = 30
    var lowestTemp: Double = 0

    // MARK: - Private properties

    private let locationID: Int
    private let initialDate: Date
    private let measurementManager: any BusinessMeasurementManagerProtocol

    /// The measurements backing the currently shown interval (used to build the lollipop entries).
    private var measurements = [any BusinessMeasurementProtocol]()

    private var currentDate: Date {
        didSet {
            Task {
                await loadValues()
            }
        }
    }

    // MARK: - Lifecycle

    init(
        locationID: Int,
        timeSpan: ChartTimeSpan,
        measurementManager: any BusinessMeasurementManagerProtocol = BusinessMeasurementManager()
    ) {
        self.locationID = locationID
        self.timeSpan = timeSpan
        self.measurementManager = measurementManager

        let startDate: Date
        switch timeSpan {
        case .day:
            startDate = .now
        case .week:
            startDate = Calendar(identifier: .iso8601)
                .dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: .now).date!
        case .month:
            let calendar = Calendar(identifier: .gregorian)
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: .now))!
        }

        self.initialDate = startDate
        self.currentDate = startDate

        Task {
            await loadValues()
        }
    }

    // MARK: - Public functions

    func advanceDate() {
        switch timeSpan {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek(currentDate))!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth(currentDate))!
        }
    }

    func reduceDate() {
        switch timeSpan {
        case .day:
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        case .week:
            currentDate = Calendar.current.date(byAdding: .day, value: -7, to: startOfWeek(currentDate))!
        case .month:
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: startOfMonth(currentDate))!
        }
    }

    func temperatureEntry(for date: Date) -> TemperatureEntry? {
        guard let measurement = measurements.first(where: {
            isEqual($0.date, date, timeSpan.chartXUnit)
        }) else {
            return nil
        }

        return TemperatureEntry(
            date: measurement.date,
            minString: measurement.lowestString,
            avgString: measurement.averageString,
            maxString: measurement.highestString
        )
    }

    // MARK: - Private functions

    private func loadValues() async {
        // The sensors are not located in GMT timezones, so we widen the requested range by a day on
        // each side to be sure to receive every value that falls inside the shown interval.
        let (start, end) = requestedRange()

        let fetched: [any BusinessMeasurementProtocol]
        switch timeSpan {
        case .day:
            fetched = (try? await measurementManager.loadHourlyMeasurements(
                for: locationID,
                startDate: start,
                endDate: end
            )) ?? []
        case .week, .month:
            fetched = (try? await measurementManager.loadDailyMeasurements(
                for: locationID,
                startDate: start,
                endDate: end
            )) ?? []
        }

        insertMeasurements(fetched)
    }

    /// The padded date range to request from the backend for the currently shown interval.
    private func requestedRange() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let intervalEnd: Date
        switch timeSpan {
        case .day:
            intervalEnd = currentDate
        case .week:
            intervalEnd = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        case .month:
            intervalEnd = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }

        let start = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        let end = calendar.date(byAdding: .day, value: 1, to: intervalEnd)!
        return (start, end)
    }

    private func insertMeasurements(_ fetched: [any BusinessMeasurementProtocol]) {
        // Keep only the measurements that fall inside the currently shown interval.
        let relevant = fetched.filter { isEqual($0.date, currentDate, timeSpan.granularity) }
        measurements = relevant

        let minValues = relevant.map { TemperatureChartPoint(measurementDate: $0.date, value: $0.lowest) }
        let avgValues = relevant.map { TemperatureChartPoint(measurementDate: $0.date, value: $0.average) }
        let maxValues = relevant.map { TemperatureChartPoint(measurementDate: $0.date, value: $0.highest) }

        data = (
            min: TemperatureSeries(type: .min, values: minValues),
            avg: TemperatureSeries(type: .avg, values: avgValues),
            max: TemperatureSeries(type: .max, values: maxValues),
            placeholder: TemperatureSeries(type: .placeholder, values: createPlaceholderMeasurements())
        )

        let lowest = relevant.map(\.lowest).min() ?? 0
        let highest = relevant.map(\.highest).max() ?? 30

        guard lowest < highest else {
            lowestTemp = 0
            highestTemp = 30
            return
        }

        lowestTemp = lowest.rounded(.down)
        highestTemp = highest.rounded(.up)
    }

    private func createPlaceholderMeasurements() -> [TemperatureChartPoint] {
        var placeholders = [TemperatureChartPoint]()

        let rangeMax: Int
        switch timeSpan {
        case .day:
            rangeMax = 23
        case .week:
            rangeMax = 6
        case .month:
            rangeMax = (Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 30) - 1
        }

        switch timeSpan {
        case .day:
            let midnightComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
            let midnightDate = Calendar.current.date(from: midnightComponents)!
            for hour in 0...rangeMax {
                placeholders.append(TemperatureChartPoint(
                    measurementDate: Calendar.current.date(byAdding: .hour, value: hour, to: midnightDate)!,
                    value: 0.0
                ))
            }

        case .week, .month:
            for day in 0...rangeMax {
                placeholders.append(TemperatureChartPoint(
                    measurementDate: Calendar.current.date(byAdding: .day, value: day, to: currentDate)!,
                    value: 0.0
                ))
            }
        }

        return placeholders
    }

    // MARK: - Calendar helpers

    private func startOfWeek(_ date: Date) -> Date {
        Calendar(identifier: .iso8601)
            .dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date!
    }

    private func startOfMonth(_ date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    }

    private func isEqual(_ lhs: Date, _ rhs: Date, _ component: Calendar.Component) -> Bool {
        Calendar.current.isDate(lhs, equalTo: rhs, toGranularity: component)
    }
}
