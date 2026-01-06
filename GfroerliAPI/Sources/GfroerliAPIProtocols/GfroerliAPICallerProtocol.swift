//
//  GfroerliAPICallerProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 23.12.2025.
//

import Foundation

public protocol GfroerliAPICallerProtocol: Sendable {
    
    /// Retrieves all locations from the remote server
    /// - Returns: Array containing all fetched locations
    func getRemoteLocations() async throws -> [any APILocationProtocol]
    
    /// Retrieves a single location from the remote server, for a given id
    /// - Parameter id: ID of the location as `Int`
    /// - Returns: Fetched location
    func getRemoteLocation(with id: Int) async throws -> any APILocationProtocol
    
    /// Retrieves a single sponsor from the remote server, for a given id of a location
    /// - Parameter id: ID of the location to get the sponsor for
    /// - Returns: Fetched sponsor
    func getRemoteSponsor(with id: Int) async throws -> any APISponsorProtocol
    
    /// Retrieves daily measurements from the remote server, for a given id of a location and a timeframe
    /// - Parameters:
    ///   - id: ID of the location to get the measurements for
    ///   - startDate: Start date of the desired period
    ///   - startDate: End date of the desired period
    /// - Returns: Array of fetched measurements
    func getRemoteDailyMeasurements(
        with id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any APIMeasurementProtocol]
    
    /// Retrieves hourly measurements from the remote server, for a given id of a location and a timeframe
    /// - Parameters:
    ///   - id: ID of the location to get the measurements for
    ///   - startDate: Start date of the desired period
    ///   - startDate: End date of the desired period
    /// - Returns: Array of fetched measurements
    func getRemoteHourlyMeasurements(
        with id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any APIMeasurementProtocol]
}
