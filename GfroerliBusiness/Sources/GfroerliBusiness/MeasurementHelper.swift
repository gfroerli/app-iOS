//
//  MeasurementHelper.swift
//  GfroerliBusiness
//
//  Created by Marc on 30.12.2025.
//

import Foundation

final class MeasurementHelper: @unchecked Sendable {
   
    // MARK: - Public properties
    
    public static let shared = MeasurementHelper()
    
    // MARK: - Private properties
    
    private lazy var measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.unitStyle = .medium
        return formatter
    }()
    
    private lazy var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Public functions
    
    public func format(_ temperature: Double) -> String {
        let measurement = Measurement<UnitTemperature>(value: temperature, unit: .celsius)
        return measurementFormatter.string(from: measurement)
    }
    
    public func relativeDateString(from date: Date) -> String {
        relativeDateFormatter.localizedString(for: date, relativeTo: .now)
    }
}
