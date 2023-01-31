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
    
    var body: some View {
        VStack {
            // We switch between a NavigationSplitView and a tab-bar view depending on the horizontal size call
            if horizontalSizeClass == .compact {
                MainView()
            }
            else {
                iPadNavigationSplitView(navModel: navigationModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBaseView()
    }
}
