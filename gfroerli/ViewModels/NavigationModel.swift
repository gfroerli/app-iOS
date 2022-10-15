//
//  NavigationModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import Combine
import Foundation
import GfroerliAPI
import SwiftUI

enum TabType: Int, Hashable, CaseIterable, Identifiable, Codable {
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
    @Published var selectedTab: TabType = .dashboard
    @Published var navigationPath: [Location] = []

    enum CodingKeys: String, CodingKey {
        case selectedTabID
        case navigationPath
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedTab.id, forKey: .selectedTabID)
        try container.encode(navigationPath.compactMap { location in location.id }, forKey: .navigationPath)
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let selectedTabID = try container.decodeIfPresent(
            Int.self, forKey: .selectedTabID
        )
        
        self.selectedTab = TabType(rawValue: selectedTabID ?? TabType.dashboard.id) ?? .dashboard
    }
    
    var jsonData: Data? {
        get {
            let data = try? JSONEncoder().encode(self)
            return data
        }
        set {
            guard let data = newValue,
                  let model = try? JSONDecoder().decode(NavigationModel.self, from: data)
            else {
                return
            }
            selectedTab = model.selectedTab
            navigationPath = model.navigationPath
        }
    }
    
    var objectWillChangeSequence:
        AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
    
    public func resetCurrentNavigationPath() {
        navigationPath.removeAll()
    }
}
