//
//  ContentSizeDeciderView.swift
//  gfroerli
//
//  Created by Marc on 04.06.23.
//

import SwiftUI

struct ContentSizeDeciderView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // MARK: - View

    var body: some View {
        if horizontalSizeClass == .compact {
            MainViewIOS()
        }
        else {
            MainViewIPadOS()
        }
    }
}

// MARK: - Preview

struct ContentSizeDeciderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentSizeDeciderView()
    }
}
