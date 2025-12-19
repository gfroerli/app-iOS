//
//  BusinessMeasurement.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliBusinessProtocols

public struct BusinessMeasurement: BusinessMeasurementProtocol {

    // MARK: - Properties

    public let date: Date
    
    public let highest: Double
    public let lowest: Double
    public let average: Double
}
