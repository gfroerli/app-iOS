//
//  File.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

public struct FetcherMock: FetcherProtocol {
    
    // MARK: - Private properties
    
    private let dataToReturn: Data
    
    // MARK: - Lifecycle
    
    public init(dataToReturn: Data) {
        self.dataToReturn = dataToReturn
    }
    
    // MARK: - FetcherProtocol
    
    public func executeRequest(for info: any GfroerliAPIProtocols.FetchInformationProtocol) async throws -> Data {
        dataToReturn
    }
}
