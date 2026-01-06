//
//  FetchInformationProtocolTests.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import GfroerliAPIMocks
import Testing

@testable import GfroerliAPI

/// Tests the URL assembly for fetching all locations
/// - Throws: -
@Test func allLocationsURLAssembly() async throws {
    let locationsInfo = FetchLocationsInformation()
    
    #expect(locationsInfo.assembleURL().absoluteString == locationsInfo.baseURL.absoluteString + "/sensors")
}
