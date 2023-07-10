//
//  MainViewIPadOS.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliBackend
import SwiftUI

struct MainViewIPadOS: View {
    typealias config = AppConfiguration.MapView

    @Environment(NavigationModel.self) var navigationModel
    @Environment(AllLocationsViewModel.self) var locationsViewModel

    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly

    @State private var searchDetent: PresentationDetent = .fraction(0.1)
    @State private var filter = 1
    @State private var region = config.defaultRegion

    @State private var showSettings = false
    @State private var showNewFeatures = false
    @State private var didAppear = false

    private var api = GfroerliBackend()

    // MARK: - Body

    var body: some View {
        @Bindable var navigationModel = navigationModel

        NavigationSplitView(columnVisibility: $columnVisibility) {
            SearchView()
        } detail: {
            NavigationStack(path: $navigationModel.navigationPath) {
                LocationMapView()

                    // MARK: - Toolbar

                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Menu {
                                Picker("main_view_filter_title", selection: $filter) {
                                    Text("main_view_filter_all").tag(0)
                                    Text("main_view_filter_active").tag(1)
                                }
                            } label: {
                                Label(
                                    "main_view_filter_label",
                                    systemImage: filter == 0 ? "line.3.horizontal.decrease.circle" :
                                        "line.3.horizontal.decrease.circle.fill"
                                )
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                withAnimation {
                                    showSettings = true
                                }
                            } label: {
                                Label("main_view_settings_label", systemImage: "gear")
                                    .labelStyle(.iconOnly)
                            }
                        }
                    }
                    .toolbarBackground(.visible, for: .navigationBar)
            }

            // MARK: - Sheets

            .sheet(isPresented: $showSettings) {
                SettingsView()
            }

            .sheet(isPresented: $showNewFeatures) {
                NewFeaturesView()
            }

            // MARK: - Change observers

            .onAppear {
                if DefaultsCoordinator.shared.showNewFeatures() {
                    showNewFeatures = true
                }
            }

            .onChange(of: navigationModel.navigationPath) { _ in
                columnVisibility = .detailOnly
            }

            // MARK: - Navigation

            .navigationTitle("main_view_navigation_title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(locationID: location.id)
            })
        }
    }

    // MARK: - Private Functions

    private enum SheetToShow {
        case search, settings, whatsNew
    }
}

// MARK: - Preview

struct MainViewIPadOS_Previews: PreviewProvider {
    static var previews: some View {
        MainViewIPadOS()
    }
}
