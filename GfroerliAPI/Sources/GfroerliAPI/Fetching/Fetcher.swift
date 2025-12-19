//
//  Fetcher.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

/// Use to execute fetch requests to the API
struct Fetcher: FetcherProtocol {
   
    // MARK: - Properties
    
    private let token: String
    
    // MARK: - Lifecycle
    
    public init(token: String = BearerToken.token) {
        self.token = token
    }
    
    // MARK: - FetcherProtocol
    
    public func executeRequest(for info: FetchInformationProtocol) async throws -> Data {
        let request = info.createRequest(token: token)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw FetchError.responseCode(httpResponse.statusCode)
        }
        
        return data
    }
}
