//
//  TemperatureMeasurement.swift
//  GfroerliBackend
//
//  Created by Marc on 11.09.22.
//

import Foundation

public struct TemperatureMeasurement: Identifiable, Hashable {
    // MARK: Properties

    public let id: UUID
    public let measurementDate: Date
    public let value: Double
    public var animate = false

    // MARK: Lifecycle

    public init(measurementDate: Date, value: Double) {
        self.id = UUID()
        self.measurementDate = measurementDate
        self.value = value
    }
}
