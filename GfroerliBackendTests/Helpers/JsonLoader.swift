//
//  JsonLoader.swift
//  GfroerliBackendTests
//
//  Created by Marc on 27.08.22.
//

import Foundation

class JsonLoader {
    static func loadJson(fileName: String) throws -> Data {
        let testBundle = Bundle(for: Self.self)
        guard
            let url = testBundle.url(forResource: fileName, withExtension: "json") else {
            fatalError()
        }
        return try! Data(contentsOf: url)
    }
}
