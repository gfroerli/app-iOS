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
    @State var searchDetent: PresentationDetent = .fraction(0.1)
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
                            Picker("Picker", selection: $filter) {
                                Text("Active").tag(1)
                                Text("All").tag(0)
                            }
                        } label: {
                            Label(
                                "Sort",
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
                            Image(systemName: "gear")
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
                            undimmed: [.fraction(0.1), .fraction(0.9)],
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

                .navigationTitle("Map")
                .navigationBarTitleDisplayMode(.inline)
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
