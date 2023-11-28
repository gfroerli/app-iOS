//
//  SortVariant+Localized.swift
//  Gfroerli
//
//  Created by Marc on 28.11.2023.
//

import Foundation
import GfroerliBackend
import SwiftUI

extension SortVariants {
    public var text: LocalizedStringKey {
        switch self {
        case .mostRecent:
            return "search_view_sort_recent"

        case .highest:
            return "search_view_sort_highest"

        case .lowest:
            return "search_view_sort_lowest"

        case .alphabet:
            return "search_view_sort_alphabetical"
        }
    }
}
