//
//  MainView.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliBackend
import SwiftUI

struct MainView: View {
    typealias config = AppConfiguration.MapView

    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel

    @State private var searchDetent: PresentationDetent = .fraction(0.1)
    @State private var filter = 1
    @State private var region = config.defaultRegion
    @State private var sheetToShow: SheetToShow = .search
    
    @State private var showSearch = false
    @State private var showSettings = false
    @State private var showNewFeatures = false
    
    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            
            LocationMapView(filter: $filter, searchDetent: $searchDetent)

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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                sheetToShow = .settings
                                showSearch = false
                            }
                        } label: {
                            Label("main_view_settings_label", systemImage: "gear")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                
                // MARK: - Sheets

                .sheet(isPresented: $showSearch, onDismiss: {
                    switch sheetToShow {
                    case .search:
                        showNewFeatures = false
                        showSettings = false
                        return
                    case .whatsNew:
                        showNewFeatures = true
                    case .settings:
                        showSettings = true
                    }
                }, content: {
                    SearchView(detent: $searchDetent)
                        .presentationDetents([.fraction(0.1), .large], selection: $searchDetent)
                        .presentationBackgroundInteraction(.enabled)
                        .interactiveDismissDisabled()
                })
            
                .sheet(isPresented: $showSettings, onDismiss: {
                    showSearch = true
                }, content: {
                    SettingsView()
                })
            
                .sheet(isPresented: $showNewFeatures, onDismiss: {
                    showSearch = true
                }, content: {
                    NewFeaturesView()
                })
                
                // MARK: - Change observers

                .onAppear {
                    if DefaultsCoordinator.shared.showNewFeatures() {
                        sheetToShow = .whatsNew
                        showNewFeatures = true
                    }
                    else {
                        sheetToShow = .search
                        showSearch = true
                    }
                }
            
                .onChange(of: navigationModel.navigationPath) { _ in
                    sheetToShow = .search
                    showSearch = navigationModel.navigationPath.isEmpty
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
