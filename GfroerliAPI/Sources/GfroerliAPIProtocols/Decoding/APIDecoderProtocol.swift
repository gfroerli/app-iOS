//
//  APIDecoderProtocol.swift
//  GfroerliAPI
//
//  Created by Marc on 19.12.2025.
//

import Foundation

package protocol APIDecoderProtocol: Sendable {
    
    /// Decodes a decodable type from data
    /// - Parameter data: `Data` to be decoded
    /// - Returns: Decoded type
    func decode<T: Decodable>(data: Data) async throws -> T
}
