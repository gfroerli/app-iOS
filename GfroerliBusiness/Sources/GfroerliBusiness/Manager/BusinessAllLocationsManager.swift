//
//  BusinessLocationManager.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation
import GfroerliAPI
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

public final class BusinessAllLocationsManager: BusinessAllLocationsManagerProtocol, Sendable {
    
    // MARK: - Private properties
    
    private let apiCaller: any GfroerliAPICallerProtocol
    private let locationValidator: LocationValidator
    
    // MARK: - Lifecycle
    
    init(apiCaller: any GfroerliAPICallerProtocol, locationValidator: any ValidatorProtocol) {
        self.apiCaller = apiCaller
        self.locationValidator = locationValidator as! LocationValidator
    }
    
    public convenience init() {
        self.init(apiCaller: GfroerliAPICaller(), locationValidator: LocationValidator())
    }
    
    // MARK: - BusinessAllLocationsManagerProtocol
    
    public func loadAllLocations() async throws -> [BusinessLocationProtocol] {
        let apiLocations: [any APILocationProtocol] = try await apiCaller.getRemoteLocations()
        let validatedLocations: [BusinessLocation] = apiLocations.compactMap { locationValidator.validate($0) }
        
        return validatedLocations
    }
}
