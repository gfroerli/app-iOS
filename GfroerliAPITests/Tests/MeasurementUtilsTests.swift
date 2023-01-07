//
//  MeasurementUtilsTests.swift
//  GfroerliAPITests
//
//  Created by Marc on 27.08.22.
//

import XCTest
@testable import GfroerliAPI

final class MeasurementUtilsTests: XCTestCase {
    
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }()
    
    // MARK: - temperatureString()

    func testTemperatureStringRoundUp() {
        // Arrange
        let temperature = 10.53
        
        // Act
        let tempString = MeasurementUtils.shared.temperatureString(from: temperature, precision: 1)
        
        // Assert
        XCTAssertEqual(tempString, "10.5°C")
    }
    
    func testTemperatureStringRoundDown() {
        // Arrange
        let temperature = 10.53
        
        // Act
        let tempString = MeasurementUtils.shared.temperatureString(from: temperature, precision: 1)
        
        // Assert
        XCTAssertEqual(tempString, "10.5°C")
    }
    
    func testTemperatureStringPrecision0() {
        // Arrange
        let temperature: Double? = 10.535
        
        // Act
        let tempString = MeasurementUtils.shared.temperatureString(from: temperature, precision: 0)
        
        // Assert
        XCTAssertEqual(tempString, "11°C")
    }
    
    func testTemperatureStringPrecision2() {
        // Arrange
        let temperature: Double? = 10.535
        
        // Act
        let tempString = MeasurementUtils.shared.temperatureString(from: temperature, precision: 2)
        
        // Assert
        XCTAssertEqual(tempString, "10.54°C")
    }
    
    func testTemperatureStringNil() {
        // Arrange
        let temperature: Double? = nil
        
        // Act
        let tempString = MeasurementUtils.shared.temperatureString(from: temperature)
        
        // Assert
        XCTAssertEqual(tempString, "-°")
    }
    
    // MARK: -  createDate()
    
    func testCreateDateNoHour() throws {
        // Arrange
        let string = "2022-08-01"
        
        // Act
        let date = MeasurementUtils.shared.createDate(date: string)
        
        // Assert
        let receivedDate = try XCTUnwrap(date)
        let year = calendar.component(.year, from: receivedDate)
        let month = calendar.component(.month, from: receivedDate)
        let day = calendar.component(.day, from: receivedDate)
        let hour = calendar.component(.hour, from: receivedDate)
        
        XCTAssertEqual(year, 2022)
        XCTAssertEqual(month, 8)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(hour, 0)
    }
    
    func testCreateDateWithHourSingleDigit() throws {
        // Arrange
        let string = "2022-08-01"
        let givenHour = 1
        
        // Act
        let date = MeasurementUtils.shared.createDate(date: string, hour: givenHour)
        
        // Assert
        let receivedDate = try XCTUnwrap(date)
        let year = calendar.component(.year, from: receivedDate)
        let month = calendar.component(.month, from: receivedDate)
        let day = calendar.component(.day, from: receivedDate)
        let hour = calendar.component(.hour, from: receivedDate)
        
        XCTAssertEqual(year, 2022)
        XCTAssertEqual(month, 8)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(hour, 1)
    }
    
    func testCreateDateWithHourMultiDigit() throws {
        // Arrange
        let string = "2022-08-01"
        let givenHour = 23
        
        // Act
        let date = MeasurementUtils.shared.createDate(date: string, hour: givenHour)
        
        // Assert
        let receivedDate = try XCTUnwrap(date)
        let year = calendar.component(.year, from: receivedDate)
        let month = calendar.component(.month, from: receivedDate)
        let day = calendar.component(.day, from: receivedDate)
        let hour = calendar.component(.hour, from: receivedDate)
        
        XCTAssertEqual(year, 2022)
        XCTAssertEqual(month, 8)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(hour, 23)
    }
}
