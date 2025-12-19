//
//  ContentView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 26.05.2024.
//

import GfroerliBusiness
import SwiftUI

struct WatchMainView: View {
    
    // View content
    @State private var viewModel = MainMapViewModel()
    
    // MARK: - Body

    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    ForEach(viewModel.activeLocations, id: \.id) { location in
                        NavigationLink(value: location.id) {
                            WatchListContentView(location: location)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .listRowBackground(
                    ZStack {
                        Color(.accent)
                        Wave(strength: 3, frequency: 7, offset: 0)
                            .foregroundStyle(.cyan.opacity(0.5))
                            .scaleEffect(x: -1, y: 1)
                            .offset(y: 3)
                        Wave(strength: 5, frequency: 6, offset: 0)
                            .foregroundStyle(.cyan.opacity(0.8))
                            .offset(y: 5)
                    }
                    .clipShape(.containerRelative)
                    .padding(.vertical, 2)
                )
                Section("inline_location_view_inactive") {
                    ForEach(viewModel.inactiveLocations, id: \.id) {
                        location in
                        NavigationLink(value: location.id) {
                            WatchListContentView(location: location)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .listRowBackground(
                    ZStack {
                        Color(.accent)
                        Wave(strength: 3, frequency: 7, offset: 0)
                            .foregroundStyle(.cyan.opacity(0.5))
                            .scaleEffect(x: -1, y: 1)
                            .offset(y: 3)
                        Wave(strength: 5, frequency: 6, offset: 0)
                            .foregroundStyle(.cyan.opacity(0.8))
                            .offset(y: 5)
                    }
                    .clipShape(.containerRelative)
                    .padding(.vertical, 2)
                )
            }
            .listStyle(.carousel)
            .navigationDestination(for: Int.self) { id in
                WatchLocationDetailTabView(viewModel: WatchLocationDetailViewModel(locationID: id))
            }
            .task {
                try? await viewModel.loadLocations()
            }
            
        } detail: {
            ContentUnavailableView("watch_nav_no_content", systemImage: "thermometer.medium")
        }
    }
}
