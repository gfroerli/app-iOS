//
//  JsonLoader.swift
//  GfroerliBackendTests
//
//  Created by Marc on 27.08.22.
//

import Foundation
import class Foundation.Bundle

public enum JsonLoader {
    public static func loadJson(fileName: String) throws -> Data {
        let testBundle = Bundle.main
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else {
            fatalError()
        }
        return try! Data(contentsOf: url)
    }
}
