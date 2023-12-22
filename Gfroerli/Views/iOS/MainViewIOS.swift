//
//  MainViewIOS.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliBackend
import SwiftUI

struct MainViewIOS: View {
    typealias config = AppConfiguration.MapView

    @Environment(NavigationModel.self) var navigationModel
    @Environment(AllLocationsViewModel.self) var locationsViewModel

    @State private var showSettings = false
    @State private var showNewFeatures = false
    @State private var query = ""
    
    let filterOptions = [0, 1]
    @State var selectedOption = 1

    // MARK: - Body

    var body: some View {
        @Bindable var navigationModel = navigationModel

        NavigationStack(path: $navigationModel.navigationPath) {
            ZStack {
                LocationMapView()
                    .ignoresSafeArea(edges: .all)
                SearchView()
            }
            .searchable(text: $query, placement: .toolbar, prompt: "main_view_search_prompt")

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
                    HStack {
                        Image(.iconBig)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .cornerRadius(5)
                        Text("Gfrör.li")
                            .bold()
                            .font(.subheadline)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("main_view_filter_label", selection: $selectedOption) {
                            ForEach(filterOptions, id: \.self) { option in
                                if option == 1 {
                                    Label("main_view_filter_active", systemImage: "thermometer.medium")
                                }
                                else {
                                    Label("main_view_filter_all", systemImage: "thermometer.medium.slash")
                                }
                            }
                        }
                    } label: {
                        if locationsViewModel.isFilterActive {
                            Label("main_view_filter_label", systemImage: "line.3.horizontal.decrease.circle.fill")
                        }
                        else {
                            Label("main_view_filter_label", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
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
            .onChange(of: query) { _, _ in
                withAnimation {
                    locationsViewModel.sortLocations(query: query)
                }
            }
            .onChange(of: locationsViewModel.sortedVariant) { _, _ in
                withAnimation {
                    locationsViewModel.sortLocations(query: query)
                }
            }
            .onChange(of: selectedOption) { _, newValue in
                if newValue == 1 {
                    locationsViewModel.isFilterActive = true
                }
                else {
                    locationsViewModel.isFilterActive = false
                }
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(for: UIApplication.willEnterForegroundNotification)
            ) { _ in
                Task {
                    await locationsViewModel.loadAllLocations()
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
