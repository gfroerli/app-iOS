//
//  WatchLocationDetailTabView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 27.05.2024.
//

import GfroerliBackend
import SwiftUI

@MainActor
struct WatchLocationDetailTabView: View {
    var locationVM: SingleLocationViewModel
    let locationID: Int
    
    init(locationID: Int) {
        self.locationID = locationID
        
        self.locationVM = SingleLocationViewModel(id: locationID)
    }

    var body: some View {
        if locationVM.location != nil {
            TabView {
                WatchTemperatureSummaryView(location: locationVM.location!)
                    .tag(0)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                WatchTemperatureHistoryView(location: locationVM.location!)
                    .tag(1)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                WatchSponsorView(sponsorVM: SponsorViewModel(id: locationID))
                    .tag(2)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
            }
            .tabViewStyle(.verticalPage)
        }
    }
}

private struct WatchLocationDetailTabViewBackground: View {
    var body: some View {
        ZStack {
            Color(.gfroerliBlue)
            Wave(strength: 3, frequency: 7, offset: 0)
                .foregroundStyle(.cyan.opacity(0.5))
                .scaleEffect(x: -1, y: 1)
                .offset(y: 18)
            Wave(strength: 5, frequency: 6, offset: 0)
                .foregroundStyle(.cyan.opacity(0.8))
                .offset(y: 22)
        }
    }
}

#Preview {
    WatchLocationDetailTabView(locationID: Location.exampleLocation().id)
}
