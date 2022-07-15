//
//  iOSMainView.swift
//  iOS
//
//  Created by Niklas Liechti on 01.07.20.
//

import SwiftUI
import MapKit
import UserNotifications

struct IOSMainView: View {
    @AppStorage("lastVersion", store: UserDefaults(suiteName: "group.ch.gfroerli")) var lastVersion: String = "0.0"

    @State var showSens = false
    @State var selectedTab = "Overview"
    @State var pathComp: String?
    @StateObject var sensorsVm = SensorListViewModel()
    @State var showUpdateView = false
    @ObservedObject var observer = Observer()
    
    var body: some View {
        // TabsView and Tabs
        TabView(selection: $selectedTab) {
            OverView(sensorsVM: sensorsVm)
                .tabItem { Image(systemName: "thermometer.sun.fill")
                    Text("Overview") }
                .tag("Overview")
        
            MapView(sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "map")
                    Text("Map") }
                .tag("Map")
            
            FavoritesView(sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "star.fill")
                    Text("Favorites") }
                .tag("Favorites")
            
            SearchView(sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "magnifyingglass")
                    Text("Search") }
                .tag("Search")
            
        }
        .sheet(isPresented: $showUpdateView) {
            WhatsNewView()
        }
       .sheet(isPresented: $showSens) {
            NavigationView {
                SensorOverView(sensorID: Int(pathComp!)!, sensorName: "")
                    .navigationBarItems(leading: Button(action: {showSens=false}, label: {Text("Close")}))
            }
        }
        // fetching Sensors
        .onAppear(perform: {
            Task { await sensorsVm.load()}
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
            if currentVersion > lastVersion {
                showUpdateView = true
            }
        })
        .onReceive(self.observer.$enteredForeground) { _ in
             Task { await sensorsVm.load()}
        }
        // DeepLink handling
        .onOpenURL(perform: { url in
            guard let tabIdentifier = url.tabIdentifier else {
                return
            }
            pathComp = url.pathComponents[1]
            selectedTab=tabIdentifier
            if selectedTab == "Overview"{
                // Workaround for SwiftUI bug
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    showSens = true
                })
            }
        })
    }
}

struct IOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
