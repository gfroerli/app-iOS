//
//  GfroerliLoader.swift
//
//
//  Created by Marc Kramer on 12.06.22.
//

import Foundation
import SwiftData

public class GfroerliBackend {
    
    public static let modelContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: [Location.self, Sponsor.self])
            return container
        }
        catch {
            fatalError()
        }
    }()
    
    public init() { }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    /// Loads given type from FetchType case
    /// - Parameters:
    ///   - type: Type to load
    ///   - types: FetchType
    /// - Returns: Type
    public func load<T: Decodable>(fetchType: FetchType) async throws -> T {
        let data = try? await Fetcher.fetch(type: fetchType)
        
        guard let data else {
            throw GfroerliBackendError.noData
        }
        let objects = try? decoder.decode(T.self, from: data)
        guard let objects else {
            fatalError()
        }
        
        return objects
    }
}
