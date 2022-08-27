//
//  MeasurementUtilsTests.swift
//  GfroerliAPITests
//
//  Created by Marc on 27.08.22.
//

import XCTest
@testable import GfroerliAPI

final class MeasurementUtilsTests: XCTestCase {
    
    // MARK: - temperatureString()
    func testTemperatureStringRoundUp() {
        // Arrange
        let temperature = 10.53
        
        // Act
        let tempString = MeasurementUtils().temperatureString(from: temperature)
        
        // Assert
        XCTAssertEqual(tempString, "10.5°C")
    }
    
    func testTemperatureStringRoundDown() {
        // Arrange
        let temperature = 10.53
        
        // Act
        let tempString = MeasurementUtils().temperatureString(from: temperature)
        
        // Assert
        XCTAssertEqual(tempString, "10.5°C")
    }
    
    func testTemperatureStringPrecision0() {
        // Arrange
        let temperature: Double? = 10.535
        
        // Act
        let tempString = MeasurementUtils().temperatureString(from: temperature, precision: 0)
        
        // Assert
        XCTAssertEqual(tempString, "11°C")
    }
    
    func testTemperatureStringPrecision2() {
        // Arrange
        let temperature: Double? = 10.535
        
        // Act
        let tempString = MeasurementUtils().temperatureString(from: temperature, precision: 2)
        
        // Assert
        XCTAssertEqual(tempString, "10.54°C")
    }
    
    func testTemperatureStringNil() {
        // Arrange
        let temperature: Double? = nil
        
        // Act
        let tempString = MeasurementUtils().temperatureString(from: temperature)
        
        // Assert
        XCTAssertEqual(tempString, "-°")
    }
}
