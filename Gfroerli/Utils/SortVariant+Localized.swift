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
            "search_view_sort_recent"

        case .highest:
            "search_view_sort_highest"

        case .lowest:
            "search_view_sort_lowest"

        case .alphabet:
            "search_view_sort_alphabetical"
        }
    }
}
