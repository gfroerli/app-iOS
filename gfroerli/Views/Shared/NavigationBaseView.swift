//
//  ContentView.swift
//  gfroerli
//
//  Created by Marc Kramer on 12.06.22.
//

import Combine
import Foundation
import GfroerliAPI
import SwiftUI

/// This "View is used to handle the base navigation on different OS's and device types
struct NavigationBaseView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    // TODO: IPad support use scene storage
    @AppStorage("navigation") private var data: Data?

    @EnvironmentObject var navigationModel: NavigationModel
    @State var selection: TabType = .dashboard
    
    var body: some View {
        VStack {
            // We switch between a NavigationSplitView and a tab-bar view depending on the horizontal size call
            if horizontalSizeClass == .compact {
                TabBarView(selection: $selection)
            }
            else {
                iPadNavigationSplitView(navModel: navigationModel)
            }
        }
        // This is needed to update navigation when switching size class on iPad
        .onChange(of: selection) { newValue in
            guard navigationModel.selectedTab != selection else {
                return
            }
            navigationModel.navigationPath.removeAll()
            navigationModel.selectedTab = newValue
        }
        .onChange(of: navigationModel.selectedTab) { newValue in
            guard newValue != selection else {
                return
            }
            navigationModel.navigationPath.removeAll()
            selection = newValue
        }
        .task {
            if let data = data {
                navigationModel.jsonData = data
            }
            for await _ in navigationModel.objectWillChangeSequence {
                // TODO: IPad support
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
