//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import SwiftUI
import GfroerliAPI

struct LocationDetailView: View {
    
    @StateObject var locationVM: SingleLocationsViewModel
    @StateObject var sponsorVM: SponsorViewModel

    init(locationID: Int) {
        _locationVM = StateObject(wrappedValue: SingleLocationsViewModel(id: locationID))
        _sponsorVM = StateObject(wrappedValue: SponsorViewModel(id: locationID))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if locationVM.location != nil {
                    LatestTemperatureView(location: $locationVM.location)
                    
                    TemperatureSummaryView(location: $locationVM.location)
                    
                    LocationMapPreviewView(location: $locationVM.location)
                    
                    if locationVM.location!.sponsorID != nil {
                        SponsorView(sponsor: $sponsorVM.sponsor)
                    }
                    
                    Spacer()
                        .navigationTitle(locationVM.location!.name)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

// MARK: - Preview
struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(locationID: 1)
    }
}
