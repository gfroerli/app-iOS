//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import SwiftUI
import GfroerliAPI

struct LocationDetailView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var locationVM: SingleLocationsViewModel
    
    init(locationID: Int) {
        _locationVM = StateObject(wrappedValue: SingleLocationsViewModel(id: locationID))
    }
    
    // MARK: - Body
    var body: some View {
        VStack{
            LatestTemperatureView(location: $locationVM.location)
            
            TemperatureSummaryView(location: $locationVM.location)
            
            LocationMapPreviewView(location: locationVM.location)
            Spacer()
                .navigationTitle(locationVM.location.name)
                .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(locationID: 1)
    }
}
