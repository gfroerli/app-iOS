//
//  TemperatureMeasurementTests.swift
//  GfroerliAPITests
//
//  Created by Marc on 28.08.22.
//

import XCTest
@testable import GfroerliAPI

final class TemperatureMeasurementTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    // MARK: - Decoding

    func testTemperatureMeasurementDecodingAllValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "TemperatureMeasurementFull")
        
        let measurementDate = dateCreator(string: "2022-08-01 2")
        let lowest = 20.0
        let average = 25.0
        let highest = 30.0
        
        // Act
        let measurement = try jsonDecoder.decode(TemperatureMeasurementCollection.self, from: data)
        
        // Assert
        XCTAssertEqual(measurement.measurementDate, measurementDate)
        XCTAssertEqual(measurement.lowest, lowest)
        XCTAssertEqual(measurement.average, average)
        XCTAssertEqual(measurement.highest, highest)
    }
    
    func testTemperatureMeasurementDecodingMissingValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "TemperatureMeasurementFull")
        
        let measurementDate = dateCreator(string: "2022-08-01 2")
        // Act
        let measurement = try jsonDecoder.decode(TemperatureMeasurementCollection.self, from: data)
        
        // Assert
        XCTAssertEqual(measurement.measurementDate, measurementDate)
    }
    
    func testTemperatureMeasurementDecodingAdditionalValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "TemperatureMeasurementAdditional")
        
        let measurementDate = dateCreator(string: "2022-08-01 2")
        // Act
        let measurement = try jsonDecoder.decode(TemperatureMeasurementCollection.self, from: data)
        
        // Assert
        XCTAssertEqual(measurement.measurementDate, measurementDate)
    }
    
    // MARK: - Helpers

    private func dateCreator(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd h"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        let someDateTime = formatter.date(from: string)
        return someDateTime
    }
}
