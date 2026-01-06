//
//  MeasurementValidator.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

struct MeasurementValidator: ValidatorProtocol {
    
    typealias ValidationInput = APIMeasurementProtocol
    typealias ValidationOutput = BusinessMeasurement
    
    // MARK: - ValidatorProtocol

    func validate(_ input: any ValidationInput) -> ValidationOutput? {
        // TODO: Fill in
        nil
    }
}
