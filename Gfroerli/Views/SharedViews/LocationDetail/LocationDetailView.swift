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
                    LatestTemperatureView(location: locationVM.location)
                        .padding(.top)

                    TemperatureSummaryView(location: locationVM.location)

                    TemperatureHistoryView(locationID: locationVM.getID())

                    LocationMapPreviewView(location: locationVM.location)

                    if locationVM.location!.sponsorID != nil {
                        SponsorView(sponsorVM: SponsorViewModel(id: locationVM.location?.id ?? -1))
                    }

                    Spacer()
                        .navigationTitle(locationVM.location?.name ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .background(Color.accentColor.opacity(0.1))
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
                .publisher(for: UIApplication.willEnterForegroundNotification)
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
