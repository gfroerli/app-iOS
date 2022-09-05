//
//  NavigationModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import Foundation
import SwiftUI
import Combine
import GfroerliAPI

enum Tabs: Int, Hashable, CaseIterable, Identifiable, Codable {
    case dashboard
    case map
    case favorites
    case search

    var id: Int { rawValue }

    var localizedName: LocalizedStringKey {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .map:
            return "Map"
        case .favorites:
            return "Favorites"
        case .search:
            return "Search"
        }
    }
    
    var symbolName: String {
        switch self {
        case .dashboard:
            return "rectangle.3.group"
        case .map:
            return "map"
        case .favorites:
            return "star"
        case .search:
            return "magnifyingglass"
        }
        
    }
}

class NavigationModel: ObservableObject, Codable {
    @Published var selectedTab: Tabs? = .dashboard
    @Published var dashboardPath: [Location] = []
    @Published var mapPath: [Location] = []

    enum CodingKeys: String, CodingKey {
        case selectedTab
        case locationPathIds
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(selectedTab, forKey: .selectedTab)
        try container.encode(dashboardPath, forKey: .locationPathIds)
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedTab = try container.decodeIfPresent(
            Tabs.self, forKey: .selectedTab)
        
        let locationPahtIds = try container.decode([Location].self, forKey: .locationPathIds)
        self.dashboardPath = [Location]()
    }
    
    var jsonData: Data? {
        get {
            try? JSONEncoder().encode(self)
        }
        set {
            guard let data = newValue,
                  let model = try? JSONDecoder().decode(NavigationModel.self, from: data)
            else { return }
            self.selectedTab = model.selectedTab
            self.dashboardPath = model.dashboardPath
            
        }
    }
    
    var objectWillChangeSequence:
        AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>>
    {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
}
