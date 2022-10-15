//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var filter = 0
    @State private var query = ""

    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            List {
                ForEach(locationsViewModel.sortedLocations) { location in
                    VStack {
                        Text(location.name)
                        Text(location.lastTemperatureDateString)
                        Text(location.latestTemperatureString)
                    }
                }
            }
            
            .searchable(text: $query)
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
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
