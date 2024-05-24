//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import GfroerliBackend
import Observation
import SwiftUI

@MainActor
struct LocationDetailView: View {
    @AppStorage("favorites") private var favorites = [Int]()

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var locationVM: SingleLocationViewModel

    @State private var isFavorite = false
    @Environment(\.modelContext) var modelContext
    let locationID: Int

    // MARK: - Lifecycle

    init(locationID: Int) {
        self.locationID = locationID
        self.locationVM = SingleLocationViewModel(id: locationID)
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if locationVM.location != nil {
                    if horizontalSizeClass == .compact {
                        LatestTemperatureView(location: locationVM.location)
                            .padding(.top)
                        TemperatureSummaryView(location: locationVM.location)
                    }
                    else {
                        HStack {
                            LatestTemperatureView(location: locationVM.location)
                            TemperatureSummaryView(location: locationVM.location)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top)
                    }

                    TemperatureHistoryView(locationID: locationVM.getID())

                    if horizontalSizeClass == .compact {
                        if locationVM.location!.sponsorID != nil {
                            LocationMapPreviewView(location: locationVM.location)
                            SponsorView(sponsorVM: SponsorViewModel(id: locationVM.location?.id ?? -1))
                        }
                    }
                    else {
                        HStack {
                            LocationMapPreviewView(location: locationVM.location)
                            if locationVM.location!.sponsorID != nil {
                                SponsorView(sponsorVM: SponsorViewModel(id: locationVM.location?.id ?? -1))
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                        .navigationTitle(locationVM.location?.name ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .padding(.horizontal)
        }
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
            await locationVM.refreshLocation()
        }
        .onAppear {
            isFavorite = favorites.contains(locationID)
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            Task {
                await locationVM.refreshLocation()
            }
        }
    }

    // MARK: - Private Functions

    @MainActor private func markAsFavorite() {
        guard let locationID: Int = locationVM.location?.id else {
            return
        }
        favorites.append(locationID)
        isFavorite = true
    }

    @MainActor private func removeFavorite() {
        guard let locationID = locationVM.location?.id,
              let index = favorites.firstIndex(of: locationID)
        else {
            return
        }
        favorites.remove(at: index)
        isFavorite = false
    }
}

// MARK: - Preview

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LocationDetailView(locationID: 1)
        }
    }
}
