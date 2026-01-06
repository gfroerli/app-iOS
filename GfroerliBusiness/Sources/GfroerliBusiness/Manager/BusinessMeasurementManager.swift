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
}
