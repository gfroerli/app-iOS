//
//  FetchInformationProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation

/// Use this to store information and create an `URLRequest` for different types
public protocol FetchInformationProtocol {
        
    /// Creates an `URLRequest` based on the given token and struct information
    /// - Parameter token: String to be used in "Authorization" header
    /// - Returns: `URLRequest` ready to be executed
    func createRequest(token: String) -> URLRequest
    
    /// Uses a base url plus other info to create the final URL for the request
    func assembleURL() -> URL
}

package extension FetchInformationProtocol {
    /// The base of the API's URL
    var baseURL: URL {
        URL(string: "https://api.gfrör.li/api/mobile_app")!
    }
}
