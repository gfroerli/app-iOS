//
//  ContentView.swift
//  gfroerli
//
//  Created by Marc Kramer on 12.06.22.
//

import SwiftUI
import GfroerliAPI
import Combine
import Foundation

/// This "View is used to handle the base navigation on different OS's and device types
struct NavigationBaseView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @SceneStorage("navigation") private var data: Data?
    @EnvironmentObject var navigationModel: NavigationModel
    @State var selection: Tabs = .dashboard
    
    var body: some View {
        VStack {
            // We switch between a NavigationSplitView and a TabbarView depending on the horizontal size call, iOS16 Beta1.
            if horizontalSizeClass == .compact {
                TabBarView(selection: $selection)
            } else {
                iPadNavigationSplitView(navModel: navigationModel)
            }
        }
        // This is needed to update navigation when switching sizeclass on iPad
        .onChange(of: selection) { newValue in
            guard navigationModel.selectedTab != selection else {
                return
            }
            navigationModel.selectedTab = newValue
        }
        .onChange(of: navigationModel.selectedTab) { newValue in
            guard newValue != selection else {
                return
            }
            selection = newValue ?? .dashboard
        }
        .task {
            if let data = data {
                navigationModel.jsonData = data
            }
            for await _ in navigationModel.objectWillChangeSequence {
                data = navigationModel.jsonData
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBaseView()
    }
}
