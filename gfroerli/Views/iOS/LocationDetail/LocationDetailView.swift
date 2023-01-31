//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import GfroerliAPI
import SwiftUI

struct LocationDetailView: View {
    
    @AppStorage("favorites") private var favorites = [Int]()

    @StateObject var locationVM: SingleLocationsViewModel
    @StateObject var sponsorVM: SponsorViewModel
    let locationID: Int
    
    @State var isFavorite = false
    init(locationID: Int) {
        _locationVM = StateObject(wrappedValue: SingleLocationsViewModel(id: locationID))
        _sponsorVM = StateObject(wrappedValue: SponsorViewModel(id: locationID))
        self.locationID = locationID
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                
                if locationVM.location != nil {
                    LatestTemperatureView(location: $locationVM.location)
                        .padding(.top)
                    
                    TemperatureSummaryView(location: $locationVM.location)
                    
                    TemperatureHistoryView(locationID: locationVM.id)
                    
                    LocationMapPreviewView(location: $locationVM.location)
                    
                    if locationVM.location!.sponsorID != nil {
                        SponsorView(sponsorVM: sponsorVM)
                    }
                    
                    Spacer()
                        .navigationTitle(locationVM.location?.name ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .toolbar {
            Button {
                isFavorite ? removeFavorite() : markAsFavorite()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .none)
                    .imageScale(.large)
            }
        }
        .onAppear {
            isFavorite = favorites.contains(locationID)
        }
    }
    
    // MARK: - Private Functions
    
    private func markAsFavorite() {
        guard let locationID: Int = locationVM.location?.id else {
            return
        }
        favorites.append(locationID)
        isFavorite = true
    }
    
    private func removeFavorite() {
        guard let locationID = locationVM.location?.id,
              let index = favorites.firstIndex(of: locationID) else {
            return
        }
        favorites.remove(at: index)
        isFavorite = false
    }
}

// MARK: - Preview

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(locationID: 1)
    }
}
