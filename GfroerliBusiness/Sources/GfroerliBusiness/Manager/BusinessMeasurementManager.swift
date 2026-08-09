//
//  BusinessMeasurementManager.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliAPI
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

public final class BusinessMeasurementManager: BusinessMeasurementManagerProtocol, Sendable {
    
    // MARK: - Private properties
    
    private let apiCaller: any GfroerliAPICallerProtocol
    private let measurementValidator: MeasurementValidator
    
    // MARK: - Lifecycle
    
    init(apiCaller: any GfroerliAPICallerProtocol, measurementValidator: any ValidatorProtocol) {
        self.apiCaller = apiCaller
        self.measurementValidator = measurementValidator as! MeasurementValidator
    }
    
    public convenience init() {
        self.init(apiCaller: GfroerliAPICaller(), measurementValidator: MeasurementValidator())
    }

    // MARK: - BusinessMeasurementManagerProtocol

    public func loadDailyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol] {
        let apiMeasurements = try await apiCaller.getRemoteDailyMeasurements(
            with: id,
            startDate: startDate,
            endDate: endDate
        )
        return apiMeasurements.compactMap { measurementValidator.validate($0) }
    }

    public func loadHourlyMeasurements(
        for id: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> [any BusinessMeasurementProtocol] {
        let apiMeasurements = try await apiCaller.getRemoteHourlyMeasurements(
            with: id,
            startDate: startDate,
            endDate: endDate
        )
        return apiMeasurements.compactMap { measurementValidator.validate($0) }
    }
}
