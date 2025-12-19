//
//  FetchLocationInformation.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

struct FetchSponsorInformation: FetchInformationProtocol {
    
    private let locationID: Int
    
    // MARK: - Lifecycle
    
    init(locationID: Int) {
        self.locationID = locationID
    }
    
    // MARK: - FetchInformationProtocol
    
    func createRequest(token: String) -> URLRequest {
        // Create request from type
        var request = URLRequest(url: assembleURL())
        
        // Set token and method
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Return request
        return request
    }
    
    func assembleURL() -> URL {
        baseURL.appending(path: "sensors/\(locationID)/sponsor")
    }
}
