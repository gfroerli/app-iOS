//
//  MainViewIOS.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//

import GfroerliBusinessProtocols
import SwiftUI

struct MainView: View {
    // Navigation
    @State private var navigationPath: [Int] = []

    // View content
    @State private var viewModel = MainMapViewModel()

    // Other properties
    @State private var showSettings = false
    @State private var query = ""

    // MARK: - Body

    var body: some View {

        NavigationStack(path: $navigationPath) {
            ZStack {
                MainMapView(viewModel: $viewModel, navigationPath: $navigationPath)
                SearchResultsView(viewModel: $viewModel)
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
                        Image(systemName: "thermometer.medium")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, Color.accentColor, Color.accentColor)
                            .imageScale(.large)
                        
                        Text("Gfrör.li")
                            .bold()
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .glassEffect(.regular)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("main_view_filter_label", selection: $viewModel.currentFilter) {
                            ForEach(MainMapViewModel.MapFilter.allCases) { filter in
                                Label(filter.title, systemImage: filter.imageName)
                                    .tag(filter.rawValue)
                            }
                        }
                    } label: {
                        Label("main_view_filter_label", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            
            // MARK: - Sheets
            
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            
            // MARK: - Change observers

            .onChange(of: query) { _, _ in
                withAnimation {
                    viewModel.updateSearchLocations(for: query)
                }
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(for: UIApplication.willEnterForegroundNotification)
            ) { _ in
                Task {
                    try? await viewModel.loadLocations()
                }
            }
            .onOpenURL { url in
                guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                      urlComponents.scheme == "gfroerli" else {
                    return
                }
                
                guard let queryItem = urlComponents.queryItems?.first as? URLQueryItem, queryItem.name == "locationID",
                      let value = queryItem.value, let id = Int(value) else {
                    return
                }
                
                navigationPath.append(id)
            }
            
            // MARK: - Navigation
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Int.self) { id in
                LocationDetailView(viewModel: LocationDetailViewModel(locationID: id))
            }
        }
    }
}
