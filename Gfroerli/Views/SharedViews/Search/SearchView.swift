//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import GfroerliAPI
import SwiftUI

struct SearchView: View {

    @Environment(NavigationModel.self) var navigationModel
    @Environment(AllLocationsViewModel.self) var locationsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isSearching) private var isSearching
    
    // MARK: - Body

    var body: some View {
        @Bindable var locationsViewModel = locationsViewModel

        VStack {
            if isSearching {
                List {
                    Section {
                        ForEach(locationsViewModel.sortedLocations) { location in
                            NavigationLink(value: location) {
                                InlineLocationView(location: location)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Results")
                            Spacer()
                            Menu {
                                ForEach(SortVariants.allCases) { variant in
                                    Button {
                                        locationsViewModel.sortedVariant = variant
                                    } label: {
                                        Label(variant.text, systemImage: variant.symbolName)
                                    }
                                }
                            } label: {
                                Label(
                                    "search_view_sort_label",
                                    systemImage: locationsViewModel.sortedVariant == SortVariants.mostRecent ? "arrow.up.arrow.down.circle" :
                                        "arrow.up.arrow.down.circle.fill"
                                )
                                .labelStyle(.iconOnly)
                            }
                        }
                    }
                }
                .background(.thinMaterial)
                .scrollContentBackground(.hidden)
            }
            else {
                EmptyView()
            }
        }
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(AllLocationsViewModel())
            .environment(NavigationModel())
    }
}
