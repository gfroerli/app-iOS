//
//  APIMeasurementProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation

/// Representation for measurements fetched from the API.
/// Note: Usually this covers a time period either a full day or an hour.
/// Contains optional values, should be validated before being used/persisted.
public protocol APIMeasurementProtocol: Decodable, Identifiable {
    /// Date the measurement was taken at
    var measurementDate: Date { get }
    /// Hour the measurement was taken at (0-23)
    var measurementHour: Int? { get }
    // Highest reading
    var highest: Double { get }
    /// Lowest reading
    var lowest: Double { get }
    /// Average reading
    var average: Double { get }
}
