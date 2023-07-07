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
