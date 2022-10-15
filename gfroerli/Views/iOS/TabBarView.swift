//
//  TabBarView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI

/// View handling the tab bar view
struct TabBarView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @Binding var selection: TabType
    
    var handler: Binding<TabType> { Binding(
        get: { self.selection },
        set: {
            navigationModel.resetCurrentNavigationPath()
            self.selection = $0
        }
    ) }
    
    var body: some View {
        TabView(selection: handler) {
            ForEach(TabType.allCases) { tab in
                switch tab {
                case .dashboard:
                    DashboardView()
                        .tabItem {
                            Label(tab.localizedName, systemImage: tab.symbolName)
                        }
                        .tag(tab)
                case .map:
                    LocationMapView()
                        .tabItem {
                            Label(tab.localizedName, systemImage: tab.symbolName)
                        }
                        .tag(tab)
                case .search:
                    SearchView()
                        .tabItem {
                            Label(tab.localizedName, systemImage: tab.symbolName)
                        }
                        .tag(tab)
                    
                case .favorites:
                    FavoritesView()
                        .tabItem {
                            Label(tab.localizedName, systemImage: tab.symbolName)
                        }
                        .tag(tab)
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selection: Binding.constant(.dashboard))
    }
}
