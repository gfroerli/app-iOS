import Foundation
import SwiftData

@available(
    *,
    deprecated,
    message: "The old backend will be replaced by `GfroerliBusiness` and `GfroerliAPI` packages in an upcoming release."
)
public class GfroerliBackend {
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
        do {
            let data = try await Fetcher.fetch(type: fetchType)
            let objects = try decoder.decode(T.self, from: data)
            return objects
        }
        catch {
            print("")
            throw error
        }
    }
}
