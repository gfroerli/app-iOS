//
//  ContentView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 26.05.2024.
//

import GfroerliBackend
import SwiftUI

struct WatchMainView: View {
    @Environment(AllLocationsViewModel.self) var locationsViewModel
    
    var body: some View {
        
        NavigationSplitView {
            List {
                Section {
                    ForEach(locationsViewModel.activeLocations) { location in
                        NavigationLink(value: location) {
                            WatchListContentView(location: location)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .listRowBackground(
                    ZStack {
                        Color(.gfroerliBlue)
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
                    ForEach(locationsViewModel.inactiveLocations) {
                        location in
                        NavigationLink(value: location) {
                            WatchListContentView(location: location)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .listRowBackground(
                    ZStack {
                        Color(.gfroerliBlue)
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
            .navigationDestination(for: Location.self) { location in
                WatchLocationDetailTabView(locationID: location.id)
            }
            .task {
                await locationsViewModel.loadAllLocations()
            }
            
        } detail: {
            ContentUnavailableView("watch_nav_no_content", systemImage: "thermometer.medium")
        }
    }
}

#Preview {
    WatchMainView()
        .environment(AllLocationsViewModel())
}
