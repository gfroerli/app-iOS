//
//  GfroerliAPICaller.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

/// Use this as the primary way of fetching items from the API.
public final class GfroerliAPICaller: GfroerliAPICallerProtocol {
    
    private let fetcher: FetcherProtocol
    private let decoder: APIDecoderProtocol
    
    // MARK: - Lifecycle
    
    init(fetcher: FetcherProtocol, decoder: APIDecoderProtocol) {
        self.fetcher = fetcher
        self.decoder = decoder
    }
    
    public convenience init() {
        self.init(fetcher: Fetcher(), decoder: APIDecoder())
    }
    
    // MARK: - Fetching functions
    
    // MARK: All locations
    
    public func getRemoteLocations() async throws -> [any APILocationProtocol] {
        let locationsFetchInfo = FetchAllLocationsInformation()
        
        // Fetch
        let locationsData = try await fetcher.executeRequest(for: locationsFetchInfo)
        
        // Decode
        let decodedLocations: [APILocation] = try await decoder.decode(data: locationsData)
        
        return decodedLocations
    }
    
    // MARK: Single location
    
    public func getRemoteLocation(with id: Int) async throws -> any APILocationProtocol {
        let locationFetchInfo = FetchLocationInformation(locationID: id)
        
        // Fetch
        let locationData = try await fetcher.executeRequest(for: locationFetchInfo)
        
        // Decode
        let decodedLocation: APILocation = try await decoder.decode(data: locationData)
        
        return decodedLocation
    }
    
    // MARK: Sponsor
    
    public func getRemoteSponsor(with id: Int) async throws -> any APISponsorProtocol {
        let sponsorFetchInfo = FetchSponsorInformation(locationID: id)
        
        // Fetch
        let sponsorData = try await fetcher.executeRequest(for: sponsorFetchInfo)
        
        // Decode
        let decodedSponsor: APISponsor = try await decoder.decode(data: sponsorData)
        
        return decodedSponsor
    }
    
    // MARK: Daily Measurements
    
    public func getRemoteDailyMeasurements(
        with id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any APIMeasurementProtocol] {
        let dailyMeasurementsFetchInfo = FetchDailyMeasurementsInformation(
            locationID: id,
            startDate: startDate,
            endDate: endDate
        )
        
        // Fetch
        let dailyMeasurementsData = try await fetcher.executeRequest(for: dailyMeasurementsFetchInfo)
        
        // Decode
        let decodedDailyMeasurements: [APIMeasurement] = try await decoder.decode(data: dailyMeasurementsData)
        
        return decodedDailyMeasurements
    }
    
    // MARK: Hourly Measurements
    
    public func getRemoteHourlyMeasurements(
        with id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any APIMeasurementProtocol] {
        let hourlyMeasurementsFetchInfo = FetchHourlyMeasurementsInformation(
            locationID: id,
            startDate: startDate,
            endDate: endDate
        )
        
        // Fetch
        let hourlyMeasurementsData = try await fetcher.executeRequest(for: hourlyMeasurementsFetchInfo)
        
        // Decode
        let decodedHourlyMeasurements: [APIMeasurement] = try await decoder.decode(data: hourlyMeasurementsData)
        
        return decodedHourlyMeasurements
    }
}
