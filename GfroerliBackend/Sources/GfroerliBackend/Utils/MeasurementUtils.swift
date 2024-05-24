//
//  MeasurementUtils.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import Foundation

public class MeasurementUtils {
    public static let shared = MeasurementUtils()

    lazy var dateFormatter = DateFormatter()

    /// Creates a localized temperature string of a given double value
    /// - Parameters:
    ///   - double: Double to be converted
    ///   - precision: Desired precision of the double
    /// - Returns: String
    public func temperatureString(from double: Double?, precision: Int = 1) -> String {
        guard let double = double else {
            return "-°"
        }
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter.maximumFractionDigits = precision
        measurementFormatter.numberFormatter.minimumFractionDigits = precision
        measurementFormatter.unitStyle = .medium
        let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
        return measurementFormatter.string(from: unit)
    }

    /// Creates a date of a given date string in format "2022-08-01", if a hour is provided as int, e.g. 0 up to 23, it
    /// is added to the date as well.
    /// - Parameters:
    ///   - date: String of format "yyyy-MM-dd"
    ///   - hour: Int between 0 and 23
    /// - Returns: Optional date
    func createDate(date: String, hour: Int? = nil) -> Date {
        var format = "yyyy/MM/dd"
        var dateString = date

        if let hour {
            format += " HH"
            dateString += " \(hour)"
        }

        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        return dateFormatter.date(from: dateString) ?? Date.distantPast
    }
}
