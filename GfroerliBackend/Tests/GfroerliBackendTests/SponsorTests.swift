//
//  SponsorTests.swift
//  GfroerliBackendTests
//
//  Created by Marc on 28.08.22.
//

import SwiftData
import XCTest
@testable import GfroerliBackend

final class SponsorTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    var modelContainer: ModelContainer?
    
    override func setUp() async throws {
        modelContainer = try ModelContainer(for: Sponsor.self, ModelConfiguration(inMemory: true))
    }
    
    // MARK: - Initialization

    func testSponsorInitAllValues() {
        // Arrange
        let id = 1
        let name = "TestName"
        let desc = "TestDesc"
        let url = URL(string: "www.example.com/sponsor")!
        
        // Act
        let sponsor = Sponsor(id: id, name: name, desc: desc, imageURL: url)
        
        // Assert
        XCTAssertEqual(sponsor.id, id)
        XCTAssertEqual(sponsor.name, name)
        XCTAssertEqual(sponsor.desc, desc)
        XCTAssertEqual(sponsor.imageURL, url)
    }
    
    // MARK: - Unwrapping

    func testSponsorUnwrapName() {
        // Arrange
        let name = "TestName"
        
        // Act
        let sponsor = Sponsor(id: 1, name: name)
        
        // Assert
        XCTAssertEqual(sponsor.name, name)
    }
    
    func testSponsorUnwrapDescription() {
        // Arrange
        let description = "Test Description"
        
        // Act
        let sponsor = Sponsor(id: 1, desc: description)
        
        // Assert
        XCTAssertEqual(sponsor.desc, description)
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
        XCTAssertEqual(sponsor.name, name)
        XCTAssertEqual(sponsor.desc, desc)
        XCTAssertEqual(sponsor.imageURL, url)
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
