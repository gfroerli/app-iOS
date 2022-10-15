//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import SwiftUI
import GfroerliAPI

struct SearchView: View {

    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var filter = 0
    @State private var query = ""

    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            List {
                ForEach(locationsViewModel.sortedLocations) { location in
                    NavigationLink(value: location) {
                        InlineLocationView(location: location)
                    }
                }
            }
            
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: query){ newValue in
                locationsViewModel.sortLocations(query: newValue)
            }
            .toolbar {
         
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("Sort", selection: $locationsViewModel.sortedBy) {
                            ForEach(AllLocationsViewModel.SortVariants.allCases) { option in
                                Label(option.text, systemImage: option.symbolName)
                            }
                        }
                    } label: {
                        Label(
                            "Sort",
                            systemImage: filter == 0 ? "arrow.up.arrow.down.circle" :
                                "arrow.up.arrow.down.circle.fill"
                        )
                    }
                }
            }
            
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(locationID: location.id)
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
