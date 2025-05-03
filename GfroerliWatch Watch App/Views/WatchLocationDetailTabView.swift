//
//  WatchLocationDetailTabView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 27.05.2024.
//

import GfroerliBackend
import SwiftUI

struct WatchLocationDetailTabView: View {
    var locationVM: SingleLocationViewModel
    var sponsorVM: SponsorViewModel
    let locationID: Int
    
    @MainActor
    init(locationID: Int) {
        self.locationID = locationID
        
        self.locationVM = SingleLocationViewModel(id: locationID)
        self.sponsorVM = SponsorViewModel(id: locationID)
    }

    @MainActor
    var body: some View {
        if locationVM.location != nil {
            TabView {
                WatchTemperatureSummaryView(location: locationVM.location!)
                    .tag(0)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                WatchTemperatureHistoryView(locationID: locationID)
                    .tag(1)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                WatchSponsorView(sponsorVM: sponsorVM)
                    .tag(2)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
            }
            .containerBackground(for: .tabView) {
                WatchLocationDetailTabViewBackground()
            }
            .tabViewStyle(.verticalPage)
        }
    }
}

private struct WatchLocationDetailTabViewBackground: View {
    
    @State var waveAnimation = false

    var body: some View {
        ZStack {
            Color(.gfroerliBlue)
            Wave(strength: 3, frequency: 7, offset: 0)
                .foregroundStyle(.cyan.opacity(0.5))
                .scaleEffect(x: -1, y: 1)
                .offset(y: waveAnimation ? 18 : 100)
                .animation(.easeInOut(duration: 0.5), value: waveAnimation)
            Wave(strength: 5, frequency: 6, offset: 0)
                .foregroundStyle(.cyan.opacity(0.8))
                .offset(y: waveAnimation ? 22 : 100)
                .animation(.easeInOut(duration: 0.7), value: waveAnimation)
        }
        .onAppear {
            waveAnimation = true
        }
        .onDisappear {
            waveAnimation = false
        }
    }
}

#Preview {
    WatchLocationDetailTabView(locationID: Location.exampleLocation().id)
}
