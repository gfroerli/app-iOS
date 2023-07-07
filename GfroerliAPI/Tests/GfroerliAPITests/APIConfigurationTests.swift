//
//  APIConfigurationTests.swift
//  GfroerliBackendTests
//
//  Created by Marc on 27.08.22.
//

import XCTest
@testable import GfroerliAPI

final class APIConfigurationTests: XCTestCase {
    
    // MARK: - preprocessDate()

    func testPreprocessDate5Days() throws {
        // Arrange
        let startDate = "2022/08/27"
        let date = dateCreator(string: startDate)
        let daysToSubstract = 5
        let expectedResult = "2022-08-22"
        
        // Act
        let resolvedDate = APIConfiguration.preprocessDate(subtractingDays: daysToSubstract, from: date!)
        
        // Assert
        XCTAssertEqual(expectedResult, resolvedDate)
    }
    
    func testPreprocessDate1Year() throws {
        // Arrange
        let startDate = "2022/08/27"
        let date = dateCreator(string: startDate)
        let daysToSubstract = 365
        let expectedResult = "2021-08-27"
        
        // Act
        let resolvedDate = APIConfiguration.preprocessDate(subtractingDays: daysToSubstract, from: date!)
        
        // Assert
        XCTAssertEqual(expectedResult, resolvedDate)
    }
    
    // MARK: - Helpers

    private func dateCreator(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: string)
        return someDateTime
    }
}
