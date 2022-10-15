//
//  FavoritesView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import GfroerliAPI
import SwiftUI

struct FavoritesView: View {
    
    @AppStorage("favorites") private var favorites = [Int]()
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel

    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            List {
                ForEach(locationsViewModel.sortedLocations) { location in
                    if favorites.contains(location.id) {
                        NavigationLink(value: location) {
                            InlineLocationView(location: location)
                        }
                    }
                }
            }
            .navigationBarTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(locationID: location.id)
            })
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
