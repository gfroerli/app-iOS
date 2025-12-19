//
//  FetchError.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

enum FetchError: Error {
    /// Thrown when we receive a status code other than 200
    case responseCode(Int)
}
