//
//  SponsorTests.swift
//  GfroerliBackendTests
//
//  Created by Marc on 28.08.22.
//

import XCTest
@testable import GfroerliBackend

final class SponsorTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    // MARK: - Intitialization

    func testSponsorInitialisationAllValues() {
        // Arrange
        let id = 1
        let name = "TestName"
        let desc = "TestDesc"
        let url = URL(string: "www.example.com/sponsor")!
        
        // Act
        let sponsor = Sponsor(id: id, jName: name, jDescription: desc, logoURL: url)
        
        // Assert
        XCTAssertEqual(sponsor.id, id)
        XCTAssertEqual(sponsor.name, name)
        XCTAssertEqual(sponsor.jDescription, desc)
        XCTAssertEqual(sponsor.logoURL, url)
    }
    
    // MARK: - Unwrapping

    func testSponsorUnwrapName() {
        // Arrange
        let name = "TestName"
        
        // Act
        let sponsor = Sponsor(id: 1, jName: name)
        
        // Assert
        XCTAssertEqual(sponsor.name, name)
    }
    
    func testSponsorUnwrapDescription() {
        // Arrange
        let description = "Test Description"
        
        // Act
        let sponsor = Sponsor(id: 1, jDescription: description)
        
        // Assert
        XCTAssertEqual(sponsor.description, description)
    }
    
    func testSponsorUnwrapNilValues() {
        // Arrange
        // Nothing to do
        
        // Act
        let sponsor = Sponsor(id: 1)
        
        // Assert
        XCTAssertEqual(sponsor.name, "No Name")
        XCTAssertEqual(sponsor.description, "No Description")
    }
    
    // MARK: - Decoding

    func testSponsorDecodingAllValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "SponsorFull")
        
        let id = 1
        let name = "TestName"
        let desc = "TestDesc"
        let url = URL(string: "www.example.com/sponsor")!
        
        // Act
        let sponsor = try jsonDecoder.decode(Sponsor.self, from: data)
        
        // Assert
        XCTAssertEqual(sponsor.id, id)
        XCTAssertEqual(sponsor.jName, name)
        XCTAssertEqual(sponsor.jDescription, desc)
        XCTAssertEqual(sponsor.logoURL, url)
    }
    
    func testSponsorDecodingMissingValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "SponsorMissing")
        
        let id = 1
        
        // Act
        let sponsor = try jsonDecoder.decode(Sponsor.self, from: data)
        
        // Assert
        XCTAssertEqual(sponsor.id, id)
    }
    
    func testSponsorDecodingAdditionalValues() throws {
        // Arrange
        let data = try JsonLoader.loadJson(fileName: "SponsorAdditional")
        
        let id = 1
        
        // Act
        let sponsor = try jsonDecoder.decode(Sponsor.self, from: data)
        
        // Assert
        XCTAssertEqual(sponsor.id, id)
    }
}
