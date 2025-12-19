//
//  APIDecoder.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

public final class APIDecoder: APIDecoderProtocol {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    public func decode<T: Decodable>(data: Data) async throws -> T {
        do {
            let objects = try decoder.decode(T.self, from: data)
            return objects
        }
        catch {
            throw error
        }
    }
}
