//
//  ValidatorProtocol.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation

public protocol ValidatorProtocol {
    associatedtype ValidationInput
    associatedtype ValidationOutput
    
    /// Validates given input to the desired output
    /// - Parameter input: `ValidationInput` to be validated
    /// - Returns: `ValidationOutput` if input was valid, else nil
    func validate(_ input: ValidationInput) -> ValidationOutput?
}
