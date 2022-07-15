//
//  MeasurementUtils.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import Foundation

class MeasurementUtils {
    
    lazy var formatter = MeasurementFormatter()
    
    func temperatureString(from double: Double?, precision: Int = 1) -> String {
        
        guard let double = double else {
            return "-"
        }

        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.unitStyle = .medium
        let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
        return formatter.string(from: unit)
    }
}
