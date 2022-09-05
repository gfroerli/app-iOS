//
//  LocationsGridView.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import SwiftUI
import GfroerliAPI

struct LocationsGridView: View {
    
    typealias config = AppConfiguration.Dashboard
    
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    private var columns: [GridItem] = {
        var columns = [GridItem(.flexible(), spacing: config.gridSpacing)]
        
        if UIDevice.isIPad {
            columns.append(GridItem(.flexible()))
        }
        
        return columns
    }()
    
    // MARK: View
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Locations")
                .font(.title)
                .bold()
                .padding(.horizontal)
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: config.gridSpacing) {
                    ForEach(locationsViewModel.activeLocations) { location in
                        NavigationLink(value: location) {
                            LocationTile(location: location)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical)
            }.scrollIndicators(.never)
        }
    }
}


struct LocationsGridView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsGridView()
    }
}
