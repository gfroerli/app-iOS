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

    /// The API delivers dates in UTC, hourly measurements additionally carry the hour separately.
    private static let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    // MARK: - ValidatorProtocol

    func validate(_ input: any ValidationInput) -> ValidationOutput? {
        // We do not allow measurements with non-finite readings.
        guard input.highest.isFinite, input.lowest.isFinite, input.average.isFinite else {
            return nil
        }

        // Hourly measurements carry the hour separately from the date, combine them into one date.
        let date: Date = if let hour = input.measurementHour {
            MeasurementValidator.utcCalendar
                .date(bySettingHour: hour, minute: 0, second: 0, of: input.measurementDate) ?? input.measurementDate
        }
        else {
            input.measurementDate
        }

        return BusinessMeasurement(
            date: date,
            highest: input.highest,
            lowest: input.lowest,
            average: input.average,
            highestString: MeasurementHelper.shared.format(input.highest),
            lowestString: MeasurementHelper.shared.format(input.lowest),
            averageString: MeasurementHelper.shared.format(input.average)
        )
    }
}
