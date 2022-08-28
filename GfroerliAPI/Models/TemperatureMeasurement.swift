//
//  TemperatureMeasurement.swift
//  
//
//  Created by Marc Kramer on 24.06.22.
//

import Foundation

public struct TemperatureMeasurement: Identifiable, Hashable {
    
    // MARK: Properties
    public let id: String?
    public let measurementDate: String?
    public let lowest: Double?
    public let average: Double?
    public let highest: Double?
}

// MARK: - Codable

extension TemperatureMeasurement: Codable {
    enum CodingKeys: String, CodingKey {
        case measurementDate = "aggregation_date"
        case lowest = "minimum_temperature"
        case highest = "maximum_temperature"
        case average = "average_temperature"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        measurementDate = try values.decodeIfPresent(String.self, forKey: .measurementDate)
        highest = try values.decodeIfPresent(Double.self, forKey: .highest)
        lowest = try values.decodeIfPresent(Double.self, forKey: .lowest)
        average = try values.decodeIfPresent(Double.self, forKey: .average)
    }
}
