//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import GfroerliAPI
import SwiftUI

struct SearchView: View {

    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var filter = 0
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(locationsViewModel.sortedLocations) { location in
                    Button(action: {
                        navigationModel.navigationPath.append(location)
                    }, label: {
                        InlineLocationView(location: location)
                    })
                    .buttonStyle(.plain)
                }
            }.listStyle(InsetGroupedListStyle())
            
                .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: query) { newValue in
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
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
