//
//  BusinessMeasurementManagerMock.swift
//  GfroerliBusiness
//
//  Created by Marc on 18.07.2026.
//

import Foundation
import GfroerliBusinessProtocols

public final class BusinessMeasurementManagerMock: BusinessMeasurementManagerProtocol {

    // MARK: - Lifecycle

    public init() { }

    // MARK: - BusinessMeasurementManagerProtocol

    public func loadDailyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol] {
        rebasedTemplate(from: startDate, to: endDate, component: .day)
    }

    public func loadHourlyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol] {
        rebasedTemplate(from: startDate, to: endDate, component: .hour)
    }

    // MARK: - Private functions

    /// Produces the handmade temperature series, re-based onto the requested date range so it always
    /// falls inside the app's current day / week / month and the graph renders populated.
    private func rebasedTemplate(from startDate: Date, to endDate: Date, component: Calendar.Component) -> [any BusinessMeasurementProtocol] {
        let template = BusinessMeasurementMock.screenshotTemplate
        guard !template.isEmpty else { return [] }

        let calendar = Calendar.current
        var result = [BusinessMeasurementMock]()

        // Start at midnight of the start day, then step by hour (hourly) or day (daily).
        var current = calendar.startOfDay(for: startDate)
        var index = 0

        while current <= endDate {
            let source = template[index % template.count]
            result.append(
                BusinessMeasurementMock(
                    date: current,
                    highest: source.highest,
                    lowest: source.lowest,
                    average: source.average
                )
            )
            guard let next = calendar.date(byAdding: component, value: 1, to: current) else { break }
            current = next
            index += 1
        }

        return result
    }
}
