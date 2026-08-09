//
//  SearchView.swift
//  gfroerli
//
//  Created by Marc on 13.09.22.
//

import GfroerliBusinessMocks
import SwiftUI

struct SearchResultsView: View {
    @Environment(\.isSearching) private var isSearching

    @Binding var viewModel: MainMapViewModel
    
    /// This is needed for previews only, since accessing `\.isSearching` is not possible.
    var searchKeyPathOverride = false
    
    // MARK: - Body

    var body: some View {

        VStack {
            if isSearching || searchKeyPathOverride {
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
                .scrollDismissesKeyboard(.immediately)
            }
            else {
                EmptyView()
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = MainMapViewModel(allLocationsManager: BusinessAllLocationsManagerMock())

    NavigationStack {
        SearchResultsView(viewModel: $viewModel, searchKeyPathOverride: true)
            .onAppear {
                Task {
                    try? await viewModel.loadLocations()
                }
            }
    }
}
