//
//  TabBarView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI

/// View handling the tab bar view
struct TabBarView: View {
    @Binding var selection: Tabs
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(Tabs.allCases) { tab in
                switch tab {
                case .dashboard:
                    DashboardView()
                    .tabItem {
                        Label(tab.localizedName, systemImage: tab.symbolName)
                            .onTapGesture {
                            selection = tab
                        }
                    }
                    .tag(tab)
                case .map:
                    LocationMapView()
                    .tabItem {
                        Label(tab.localizedName, systemImage: tab.symbolName)
                            .onTapGesture {
                            selection = tab
                        }
                    }
                    .tag(tab)
                default:
                    Text("DEFAULT")
                        .tabItem {
                            Label(tab.localizedName, systemImage: tab.symbolName)
                                .onTapGesture {
                                    selection = tab
                                }
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
