//
//  MainViewIOS.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliAPI
import SwiftUI

struct MainViewIOS: View {
    typealias config = AppConfiguration.MapView
    
    @Environment(NavigationModel.self) var navigationModel
    @Environment(AllLocationsViewModel.self) var locationsViewModel
    
    @State private var showSettings = false
    @State private var showNewFeatures = false
    @State private var query = ""
    
    // MARK: - Body
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        NavigationStack(path: $navigationModel.navigationPath) {
            
            ZStack {
                LocationMapView()
                SearchView()
            }
            .searchable(text: $query, placement: .toolbar)
            
            
            // MARK: - Toolbar
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Label("main_view_settings_label", systemImage: "gear")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Image(.iconBig)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .cornerRadius(5)
                }
                
            }
            .toolbarBackground(.visible, for: .navigationBar)
            
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
            .onChange(of: query) { oldValue, newValue in
                withAnimation {
                    locationsViewModel.sortLocations(query: query)
                }
            }
            .onChange(of: locationsViewModel.sortedVariant) { oldValue, newValue in
                withAnimation {
                    locationsViewModel.sortLocations(query: query)
                }
            }
            
            // MARK: - Navigation
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(locationID: location.id)
            })
        }
    }
}

// MARK: - Preview

struct MainViewIOS_Previews: PreviewProvider {
    static var previews: some View {
        MainViewIOS()
            .environment(AllLocationsViewModel())
            .environment(NavigationModel())
    }
}
