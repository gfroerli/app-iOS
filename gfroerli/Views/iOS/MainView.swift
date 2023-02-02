//
//  MainView.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliAPI
import SwiftUI

struct MainView: View {
    typealias config = AppConfiguration.MapView

    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel

    @State var showSearch = true
    @State var searchDetent: PresentationDetent = .fraction(0.2)
    @State private var filter = 1
    @State private var region = config.defaultRegion
    @State private var sheetToShow: SheetToShow = .none

    @State var showSettings = false
    @State var showNewFeatures = false
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            
            LocationMapView(filter: $filter, searchDetent: $searchDetent)

                // MARK: - Toolbar

                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Picker("main_view_filter_title", selection: $filter) {
                                Text("main_view_filter_active").tag(1)
                                Text("main_view_filter_all").tag(0)
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
                
                // MARK: - Sheets

                .sheet(isPresented: $showSearch, onDismiss: {
                    switch sheetToShow {
                    case .none:
                        return
                    case .whatsNew:
                        showNewFeatures = true
                    case .settings:
                        showSettings = true
                    }
                }, content: {
                    SearchView()
                        .interactiveDismissDisabled()
                        .presentationDetents(
                            undimmed: [.fraction(0.15), .fraction(0.9)],
                            selection: $searchDetent
                        )
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
                        showSearch = false
                    }
                }
            
                .onChange(of: navigationModel.navigationPath) { _ in
                    sheetToShow = .none
                    showSearch = navigationModel.navigationPath.isEmpty
                }
            
                // MARK: - Navigation

                .navigationTitle("main_view_navigation_title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(for: Location.self, destination: { location in
                    LocationDetailView(locationID: location.id)
                })
        }
    }
    
    // MARK: - Private Functions
    
    private enum SheetToShow {
        case none, settings, whatsNew
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
