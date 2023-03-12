//
//  ScreenShotContent.swift
//  gfroerliUITests
//
//  Created by Marc on 12.03.23.
//

import Foundation
import SwiftUI

public enum ScreenshotContent {
    case overview, detail, search
    
    public var localizedTitle: String {
        let key: String!

        switch self {
        case .overview:
            key = "screenshot_overview_title"
        case .detail:
            key = "screenshot_detail_title"
        case .search:
            key = "screenshot_search_title"
        }
        return NSLocalizedString(key, bundle: Bundle.current, comment: "")
    }
    
    public var localizedDescription: String {
        let key: String!
        
        switch self {
        case .overview:
            key = "screenshot_overview_description"
        case .detail:
            key = "screenshot_detail_description"
        case .search:
            key = "screenshot_search_description"
        }
        
        return NSLocalizedString(key, bundle: Bundle.current, comment: "")
    }
}
