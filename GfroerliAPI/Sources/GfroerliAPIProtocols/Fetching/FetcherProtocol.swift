//
//  FetcherProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation

public protocol FetcherProtocol: Sendable {
    
    /// Executes an `URLRequest` based on the passed `FetchInformation`
    /// - Parameter info: `FetchInformation` the request is based on
    /// - Returns: `Data` if response status returned 200, else throws
    func executeRequest(for info: FetchInformationProtocol) async throws -> Data
}
