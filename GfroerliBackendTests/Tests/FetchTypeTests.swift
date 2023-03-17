//
//  FetchTypeTests.swift
//  GfroerliBackendTests
//
//  Created by Marc on 27.08.22.
//

import XCTest
@testable import GfroerliBackend

final class FetchTypeTests: XCTestCase {
    // MARK: - .allLocations

    func testAllLocationsURL() {
        // Arrange
        let url = FetchType.allLocations.assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(url.description, "https://watertemp-api.coredump.ch//api/mobile_app/sensors")
    }
    
    // MARK: - .singleLocation

    func testSingleLocationURLIDIs1() {
        // Arrange
        let id = 1
        let url = FetchType.singleLocation(id: id).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(url.description, "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)")
    }
    
    func testSingleLocationURLIDIs2() {
        // Arrange
        let id = 2
        let url = FetchType.singleLocation(id: id).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(url.description, "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)")
    }
    
    // MARK: - .sponsor

    func testSponsorURLIDIs1() {
        // Arrange
        let id = 1
        let url = FetchType.sponsor(id: id).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(url.description, "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)/sponsor")
    }
    
    func testSponsorURLIDIs2() {
        // Arrange
        let id = 2
        let url = FetchType.sponsor(id: id).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(url.description, "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)/sponsor")
    }
    
    // MARK: - .hourlyTemperatures

    func testhourlyTemperatures() {
        // Arrange
        let locationID = 1
        let startDate = dateCreator(string: "2022/08/26")!
        
        let expectedStartDateSting = "2022-08-25"
        let expectedEndDateSting = "2022-08-27"
        
        let url = FetchType.hourlyTemperatures(locationID: locationID, of: startDate).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(
            url.description,
            "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/hourly_temperatures?from=\(expectedStartDateSting)&to=\(expectedEndDateSting)&limit=100"
        )
    }
    
    func testhourlyTemperatures2() {
        // Arrange
        let locationID = 2
        let startDate = dateCreator(string: "2021/07/25")!
        
        let expectedStartDateSting = "2021-07-24"
        let expectedEndDateSting = "2021-07-26"
        
        let url = FetchType.hourlyTemperatures(locationID: locationID, of: startDate).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(
            url.description,
            "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/hourly_temperatures?from=\(expectedStartDateSting)&to=\(expectedEndDateSting)&limit=100"
        )
    }
    
    // MARK: - .dailyTemperatures

    func testDailyTemperatures1() {
        // Arrange
        let locationID = 1
        let startDate = dateCreator(string: "2022/08/26")!
        let endDate = dateCreator(string: "2022/08/27")!
        
        let expectedStartDateSting = "2022-08-26"
        let expectedEndDateSting = "2022-08-27"
        
        let url = FetchType.dailyTemperatures(locationID: locationID, from: startDate, to: endDate).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(
            url.description,
            "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/daily_temperatures?from=\(expectedStartDateSting)&to=\(expectedEndDateSting)&limit=100"
        )
    }
    
    func testDailyTemperatures2() {
        // Arrange
        let locationID = 2
        let startDate = dateCreator(string: "2021/07/25")!
        let endDate = dateCreator(string: "2021/07/26")!
        
        let expectedStartDateSting = "2021-07-25"
        let expectedEndDateSting = "2021-07-26"
        
        let url = FetchType.dailyTemperatures(locationID: locationID, from: startDate, to: endDate).assembledURL
        
        // Act
        // Nothing to do
        
        // Assert
        XCTAssertEqual(
            url.description,
            "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/daily_temperatures?from=\(expectedStartDateSting)&to=\(expectedEndDateSting)&limit=100"
        )
    }
    
    // MARK: - Helpers

    private func dateCreator(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: string)
        return someDateTime
    }
}
