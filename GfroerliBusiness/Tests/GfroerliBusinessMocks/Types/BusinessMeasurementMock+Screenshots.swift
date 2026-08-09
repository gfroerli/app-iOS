//
//  BusinessMeasurementMock+Screenshots.swift
//  GfroerliBusiness
//
//  Handmade fixture measurements used to populate the temperature-history graph for App Store
//  screenshots (see the `-uiScreenshots` launch mode) without hitting the server.
//

import Foundation

public extension BusinessMeasurementMock {

    /// A believable min/avg/max value template (matches "Bern, Aare"), used as the source for
    /// screenshot measurements. `BusinessMeasurementManagerMock` re-bases these values onto whatever
    /// date range it is asked for, so the graph is never empty regardless of the current day.
    ///
    /// - Note: The dates are placeholders; the mock manager overwrites them per requested range.
    static let screenshotTemplate: [BusinessMeasurementMock] = [
        BusinessMeasurementMock(date: .distantPast, highest: 23.01, lowest: 21.80, average: 22.41),
        BusinessMeasurementMock(date: .distantPast, highest: 23.83, lowest: 22.18, average: 22.94),
        BusinessMeasurementMock(date: .distantPast, highest: 23.42, lowest: 22.57, average: 22.90),
        BusinessMeasurementMock(date: .distantPast, highest: 24.82, lowest: 22.74, average: 23.75),
        BusinessMeasurementMock(date: .distantPast, highest: 23.86, lowest: 21.79, average: 22.90),
        BusinessMeasurementMock(date: .distantPast, highest: 24.03, lowest: 22.12, average: 23.21),
    ]
}
