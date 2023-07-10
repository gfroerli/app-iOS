//
//  TemperatureMeasurement.swift
//
//
//  Created by Marc Kramer on 24.06.22.
//

import Foundation

public struct TemperatureMeasurementCollection: Identifiable, Hashable {
    public init(id: String, measurementDate: Date, lowest: Double, average: Double, highest: Double) {
        self.id = id
        self.measurementDate = measurementDate
        self.lowest = lowest
        self.average = average
        self.highest = highest
    }

    // MARK: Properties

    public let id: String
    public let measurementDate: Date
    public let lowest: Double
    public let average: Double
    public let highest: Double
}

// MARK: - Decodable

extension TemperatureMeasurementCollection: Decodable {
    enum CodingKeys: String, CodingKey {
        case measurementDate = "aggregation_date"
        case measurementHour = "aggregation_hour"
        case lowest = "minimum_temperature"
        case highest = "maximum_temperature"
        case average = "average_temperature"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.highest = try values.decode(Double.self, forKey: .highest)
        self.lowest = try values.decode(Double.self, forKey: .lowest)
        self.average = try values.decode(Double.self, forKey: .average)

        let date = try values.decode(String.self, forKey: .measurementDate)
        let hour = try values.decodeIfPresent(Int.self, forKey: .measurementHour)

        self.measurementDate = MeasurementUtils.shared.createDate(date: date, hour: hour)
    }
}
