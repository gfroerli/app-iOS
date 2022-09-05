//
//  NavigationSplitView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI

/// View handling the split navigation
struct iPadNavigationSplitView: View {
    @ObservedObject var navModel: NavigationModel
    
    var body: some View {
        NavigationSplitView {
            List(
                Tabs.allCases, selection: $navModel.selectedTab
            ) { tab in
                NavigationLink(value: tab) {
                    Label(tab.localizedName, systemImage: tab.symbolName)
                }
            }
            .navigationTitle("Categories")
            .navigationSplitViewStyle(.balanced)
            
        } detail: {
            NavigationStack(path: $navModel.dashboardPath) {
                switch navModel.selectedTab {
                case .dashboard:
                    DashboardView()
                case .map:
                    LocationMapView()
                default:
                    Text("DEFAULT")
                }
            }
        }
    }
}

struct iPadNavigationSplitView_Previews: PreviewProvider {
    static var previews: some View {
        iPadNavigationSplitView(navModel: NavigationModel())
    }
}
