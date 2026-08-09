//
//  BusinessMeasurementManagerProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation

public protocol BusinessMeasurementManagerProtocol: Sendable {

    /// Loads daily aggregated measurements for a location within a timeframe.
    /// - Parameters:
    ///   - id: ID of the location to get the measurements for
    ///   - startDate: Start date of the desired period
    ///   - endDate: End date of the desired period
    /// - Returns: Array of validated, display-ready measurements
    func loadDailyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol]

    /// Loads hourly aggregated measurements for a location within a timeframe.
    /// - Parameters:
    ///   - id: ID of the location to get the measurements for
    ///   - startDate: Start date of the desired period
    ///   - endDate: End date of the desired period
    /// - Returns: Array of validated, display-ready measurements
    func loadHourlyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol]
}
