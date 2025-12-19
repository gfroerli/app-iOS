//
//  BusinessLocationManager.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliAPI
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

public final class BusinessLocationManager: BusinessLocationManagerProtocol, Sendable {
    
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
    
    // MARK: - BusinessLocationManagerProtocol

    public func loadLocation(with id: Int) async throws -> (any BusinessLocationProtocol)? {
        let apiLocation: any APILocationProtocol = try await apiCaller.getRemoteLocation(with: id)
        let validatedLocation = locationValidator.validate(apiLocation)
        
        return validatedLocation
    }
}
