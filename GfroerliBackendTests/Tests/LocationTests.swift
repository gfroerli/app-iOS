//
//  LocationTests.swift
//  GfroerliBackendTests
//
//  Created by Marc on 27.08.22.
//

import CoreLocation
import XCTest
@testable import GfroerliBackend

final class LocationTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    // MARK: - Intitialization

    func testLocationInitialisationAllValues() {
        // Arrange
        let id = 1
        let name = "TestName"
        let desc = "TestDesc"
        let lat = 1.0
        let long = 2.0
        let creationDate = Date()
        let sponsorID = 2
        let latestTemp = 10.0
        let latestTempDate = Date()
        let highest = 20.0
        let lowest = 0.0
        let avg = 10.0
        
        // Act
        let location = Location(
            id: id,
            jName: name,
            jDescription: desc,
            jLatitude: lat,
            jLongitude: long,
            creationDate: creationDate,
            sponsorID: sponsorID,
            latestTemperature: latestTemp,
            lastTemperatureDate: latestTempDate,
            highestTemperature: highest,
            lowestTemperature: lowest,
            averageTemperature: avg
        )
        
        // Assert
        XCTAssertEqual(location.id, id)
        XCTAssertEqual(location.jName, name)
        XCTAssertEqual(location.jDescription, desc)
        XCTAssertEqual(location.jLatitude, lat)
        XCTAssertEqual(location.jLongitude, long)
        XCTAssertEqual(location.creationDate, creationDate)
        
        XCTAssertEqual(location.sponsorID, sponsorID)
        
        XCTAssertEqual(location.latestTemperature, latestTemp)
        XCTAssertEqual(location.jLastTemperatureDate, latestTempDate)
        
        XCTAssertEqual(location.highestTemperature, highest)
        XCTAssertEqual(location.lowestTemperature, lowest)
        XCTAssertEqual(location.averageTemperature, avg)
    }
    
    // MARK: - Unwrapping

    func testLocationUnwrapName() {
        // Arrange
        let name = "TestName"
        
        // Act
        let location = Location(id: 1, jName: name)
        
        // Assert
        XCTAssertEqual(location.name, name)
    }
    
    func testLocationUnwrapDescription() {
        // Arrange
        let description = "Test Description"
        
        // Act
        let location = Location(id: 1, jDescription: description)
        
        // Assert
        XCTAssertEqual(location.description, description)
    }
    
    func testLocationUnwrapCoordinates() {
        // Arrange
        let lat = 1.0
        let long = 2.0
        let coords = CLLocation(latitude: lat, longitude: long)
        
        // Act
        let location = Location(id: 1, jLatitude: lat, jLongitude: long)
        
        // Assert
        XCTAssertEqual(location.coordinates?.coordinate.latitude, coords.coordinate.latitude)
        XCTAssertEqual(location.coordinates?.coordinate.longitude, coords.coordinate.longitude)
    }
    
    func testLocationUnwrapLatestTempString() {
        // Arrange
        let temp = 20.0
        let tempString = MeasurementUtils.shared.temperatureString(from: temp)
        // Act
        let location = Location(id: 1, latestTemperature: temp)
        
        // Assert
        XCTAssertEqual(location.latestTemperatureString, tempString)
    }
    
    func testLocationUnwrapHighestTempString() {
        // Arrange
        let temp = 20.0
        let tempString = MeasurementUtils.shared.temperatureString(from: temp)
        // Act
        let location = Location(id: 1, highestTemperature: temp)
        
        // Assert
        XCTAssertEqual(location.highestTemperatureString, tempString)
    }

    func testLocationUnwrapLowestTempString() {
        // Arrange
        let temp = 20.0
        let tempString = MeasurementUtils.shared.temperatureString(from: temp)
        // Act
        let location = Location(id: 1, lowestTemperature: temp)
        
        // Assert
        XCTAssertEqual(location.lowestTemperatureString, tempString)
    }
    
    func testLocationUnwrapAverageTempString() {
        // Arrange
        let temp = 20.0
        let tempString = MeasurementUtils.shared.temperatureString(from: temp)
        // Act
        let location = Location(id: 1, averageTemperature: temp)
        
        // Assert
        XCTAssertEqual(location.averageTemperatureString, tempString)
    }
    
    func testLocationUnwrapNilValues() {
        // Arrange
        // Nothing to do
        
        // Act
        let location = Location(id: 1)
        
        // Assert
        XCTAssertEqual(location.name, "No Name")
        XCTAssertEqual(location.description, "No Description")
        XCTAssertEqual(location.coordinates, nil)
        XCTAssertEqual(location.lastTemperatureDateString, "Unknown")
        XCTAssertEqual(location.latestTemperatureString, "-°")
        XCTAssertEqual(location.highestTemperatureString, "-°")
        XCTAssertEqual(location.lowestTemperatureString, "-°")
        XCTAssertEqual(location.averageTemperatureString, "-°")
    }
    
    // MARK: - Decoding

    func testLocationDecodingAllValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "LocationFull")
        
        let id = 1
        let name = "TestName"
        let desc = "TestDesc"
        let lat = 1.0
        let long = 2.0
        let creationDate = Date(timeIntervalSinceReferenceDate: 10)
        let sponsorID = 2
        let latestTemp = 10.0
        let latestTempDate = Date(timeIntervalSinceReferenceDate: 20)
        let highest = 20.0
        let lowest = 0.0
        let avg = 10.0
        
        // Act
        let location = try jsonDecoder.decode(Location.self, from: data)
        
        // Assert
        XCTAssertEqual(location.id, id)
        XCTAssertEqual(location.jName, name)
        XCTAssertEqual(location.jDescription, desc)
        XCTAssertEqual(location.jLatitude, lat)
        XCTAssertEqual(location.jLongitude, long)
        XCTAssertEqual(location.creationDate, creationDate)
        
        XCTAssertEqual(location.sponsorID, sponsorID)
        
        XCTAssertEqual(location.latestTemperature, latestTemp)
        XCTAssertEqual(location.jLastTemperatureDate, latestTempDate)
        
        XCTAssertEqual(location.highestTemperature, highest)
        XCTAssertEqual(location.lowestTemperature, lowest)
        XCTAssertEqual(location.averageTemperature, avg)
    }
    
    func testLocationDecodingMissingValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "LocationMissing")
        
        let id = 1
        
        // Act
        let location = try jsonDecoder.decode(Location.self, from: data)
        
        // Assert
        XCTAssertEqual(location.id, id)
    }
    
    func testLocationDecodingAdditionalValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "LocationAdditional")
        
        let id = 1
        
        // Act
        let location = try jsonDecoder.decode(Location.self, from: data)
        
        // Assert
        XCTAssertEqual(location.id, id)
    }
}
