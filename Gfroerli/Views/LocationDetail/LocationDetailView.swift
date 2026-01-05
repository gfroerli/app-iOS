//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import GfroerliBusinessMocks
import Observation
import SwiftUI

@MainActor
struct LocationDetailView: View {
    @AppStorage("favorites") private var favorites = [Int]()
    
    @State private var viewModel: LocationDetailViewModel

    @State private var isFavorite = false

    // MARK: - Lifecycle

    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if let location = viewModel.location {
                    LocationDetailLastTemperatureView(location: location)
                    LocationDetailTemperatureSummaryView(location: location)
                    
                    LocationTemperatureHistoryView(locationID: viewModel.locationID)
                    
                    if let sponsor = viewModel.sponsor {
                        SponsorView(sponsor: sponsor)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.location?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            Button {
                isFavorite ? removeFavorite() : markAsFavorite()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isFavorite ? .yellow : .accentColor)
                    .imageScale(.large)
            }
        }
        .refreshable {
            try? await viewModel.loadLocation()
        }
        .onAppear {
            Task {
                try? await viewModel.loadLocation()
            }
            // isFavorite = favorites.contains(locationID)
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            Task {
                try? await viewModel.loadLocation()
            }
        }
    }

    // MARK: - Private Functions

    @MainActor private func markAsFavorite() {
        guard let locationID: Int = viewModel.location?.id else {
            return
        }
        favorites.append(locationID)
        isFavorite = true
    }

    @MainActor private func removeFavorite() {
        guard let locationID = viewModel.location?.id,
              let index = favorites.firstIndex(of: locationID)
        else {
            return
        }
        favorites.remove(at: index)
        isFavorite = false
    }
}

#Preview {
    @Previewable @State var viewModel = LocationDetailViewModel(
        locationID: 0,
        locationManager: BusinessLocationManagerMock(),
        sponsorManager: BusinessSponsorManagerMock()
    )
    
    NavigationStack {
        LocationDetailView(
            viewModel: viewModel
        )
    }
}
