//
//  DashboardView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI
import GfroerliAPI

struct DashboardView: View {

    typealias config = AppConfiguration.Dashboard

    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State var showSettings = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationModel.locationPath){
            ScrollView(.vertical) {
                LocationsGridView()
            }
            .toolbar{
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
            .sheet(isPresented: $showSettings, content: {
                SettingsView()
            })
            
            // MARK: Navigation
            .navigationTitle("Dashboard")
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(locationID: location.id)
            })
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
