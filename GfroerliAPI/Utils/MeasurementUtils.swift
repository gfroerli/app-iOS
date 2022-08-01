//
//  MeasurementUtils.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import Foundation

class MeasurementUtils {
    
    lazy var formatter = MeasurementFormatter()
    
    /// Creates a localized temperature string of a given double value
    /// - Parameters:
    ///   - double: Double to be converted
    ///   - precision: Desired precision of the double
    /// - Returns: String
    func temperatureString(from double: Double?, precision: Int = 1) -> String {
        
        guard let double = double else {
            return "-°"
        }

        formatter.numberFormatter.maximumFractionDigits = precision
        formatter.numberFormatter.minimumFractionDigits = precision
        formatter.unitStyle = .medium
        let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
        return formatter.string(from: unit)
    }
}
