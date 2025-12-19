//
//  BusinessMeasurementProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation

/// Representation for measurements ready to be used in UI etc.
public protocol BusinessMeasurementProtocol {
    /// Date the measurement was taken at
    var date: Date { get }
    // Highest reading
    var highest: Double { get }
    /// Lowest reading
    var lowest: Double { get }
    /// Average reading
    var average: Double { get }
}
