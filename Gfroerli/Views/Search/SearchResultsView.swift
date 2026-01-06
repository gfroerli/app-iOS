//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.isSearching) private var isSearching

    @Binding var viewModel: MainMapViewModel

    // MARK: - Body

    var body: some View {

        VStack {
            if isSearching {
                List {
                    Section {
                        ForEach(viewModel.searchResultLocations, id: \.id) { location in
                            NavigationLink(value: location.id) {
                                InlineLocationView(location: location)
                            }
                        }
                    } header: {
                        Text("search_view_results_title")
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
