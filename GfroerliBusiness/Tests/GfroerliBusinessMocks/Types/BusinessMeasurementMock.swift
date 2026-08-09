//
//  BusinessMeasurementMock.swift
//  GfroerliBusiness
//
//  Created by Marc on 18.07.2026.
//

import Foundation
import GfroerliBusinessProtocols

public struct BusinessMeasurementMock: BusinessMeasurementProtocol, Sendable {

    // MARK: - BusinessMeasurementProtocol

    public var date: Date

    public var highest: Double
    public var lowest: Double
    public var average: Double

    public var highestString: String
    public var lowestString: String
    public var averageString: String
}

public extension BusinessMeasurementMock {

    /// Convenience initializer for fixtures: derives the display strings from the raw values so only
    /// the server-shaped fields need to be provided. Formatting matches the real `MeasurementHelper`
    /// (1 fraction digit, localized unit style), while always displaying Celsius.
    init(date: Date, highest: Double, lowest: Double, average: Double) {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.unitStyle = .medium
        // Always display Celsius; don't let the locale convert to Fahrenheit (e.g. en-US).
        formatter.unitOptions = .providedUnit

        func string(_ value: Double) -> String {
            formatter.string(from: Measurement<UnitTemperature>(value: value, unit: .celsius))
        }

        self.init(
            date: date,
            highest: highest,
            lowest: lowest,
            average: average,
            highestString: string(highest),
            lowestString: string(lowest),
            averageString: string(average)
        )
    }
}
