//
//  WatchLocationDetailTabView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 27.05.2024.
//

import GfroerliBusinessMocks
import SwiftUI

struct WatchLocationDetailTabView: View {

    @State private var viewModel: WatchLocationDetailViewModel
    
    // MARK: - Lifecycle

    init(viewModel: WatchLocationDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    @MainActor
    var body: some View {
        TabView {
            if let location = viewModel.location {
                WatchTemperatureSummaryView(location: location)
                    .tag(0)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                WatchTemperatureHistoryView(locationID: location.id)
                    .tag(1)
                    .containerBackground(for: .tabView) {
                        WatchLocationDetailTabViewBackground()
                    }
                
                if let sponsor = viewModel.sponsor {
                    WatchSponsorView(sponsor: sponsor)
                        .tag(2)
                        .containerBackground(for: .tabView) {
                            WatchLocationDetailTabViewBackground()
                        }
                }
            }
        }
        .tabViewStyle(.verticalPage)
        .onAppear {
            Task {
                try? await viewModel.loadLocation()
            }
        }
    }
}

private struct WatchLocationDetailTabViewBackground: View {
    
    @State var waveAnimation = false

    var body: some View {
        ZStack {
            Color(.accent)
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
    @Previewable @State var viewModel = WatchLocationDetailViewModel(
        locationID: 0,
        locationManager: BusinessLocationManagerMock(),
        sponsorManager: BusinessSponsorManagerMock()
    )
    NavigationView {
        WatchLocationDetailTabView(viewModel: viewModel)
    }
}
