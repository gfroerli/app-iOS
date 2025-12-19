//
//  APIMeasurement.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation
import GfroerliAPIProtocols

internal final class APIMeasurement: APIMeasurementProtocol {
   
    // MARK: - Properties

    public let measurementDate: Date
    public let measurementHour: Int?

    public let highest: Double
    public let lowest: Double
    public let average: Double
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()
    
    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case measurementDate = "aggregation_date"
        case measurementHour = "aggregation_hour"
        
        case highest = "maximum_temperature"
        case lowest = "minimum_temperature"
        case average = "average_temperature"
    }
    
    // MARK: - Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .measurementDate)
        self.measurementDate = APIMeasurement.dateFormatter.date(from: dateString)!
        self.measurementHour = try container.decodeIfPresent(Int.self, forKey: .measurementHour)

        self.highest = try container.decode(Double.self, forKey: .highest)
        self.lowest = try container.decode(Double.self, forKey: .lowest)
        self.average = try container.decode(Double.self, forKey: .average)
    }
}
