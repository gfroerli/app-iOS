//
//  Fetcher.swift
//  
//
//  Created by Marc Kramer on 12.06.22.
//

import Foundation

public class Fetcher {
    
    /// Fetches the data of a given type
    /// - Parameter type: FetchType
    /// - Returns: Data
    public static func fetch(type: FetchType) async throws -> Data {
        let url = type.assembledURL
        
        var request = URLRequest(url: url)
        request.setValue(BearerToken.bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
