//
//  File.swift
//
//
//  Created by Marc on 27.06.2023.
//

import Foundation
import SwiftUI

public enum SortVariants: CaseIterable, Identifiable {
    case alphabet
    case lowest
    case highest
    case mostRecent

    public var id: SortVariants { self }

    public var symbolName: String {
        switch self {
        case .mostRecent:
            return "clock"

        case .highest:
            return "thermometer.sun.fill"

        case .lowest:
            return "thermometer.snowflake"

        case .alphabet:
            return "abc"
        }
    }
}
