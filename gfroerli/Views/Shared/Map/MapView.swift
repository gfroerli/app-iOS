//
//  MapView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI
import MapKit
import GfroerliAPI

struct LocationMapView: View {
    
    typealias config = AppConfiguration.MapView
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var filter: Int = 0
    @State private var region =  config.defaultRegion
    
    var body: some View {
        NavigationStack(path: $navigationModel.mapPath){
            
            Map(coordinateRegion: $region, annotationItems: annotationLocations()) { location in
                MapAnnotation(coordinate: location.coordinates?.coordinate ?? config.defaultCoordinates.coordinate) {
                    
                    if location.coordinates == nil {
                        EmptyView()
                    } else if region.span.latitudeDelta <= 0.1 {
                        GfroerliMapAnnotation(location: location)
                    } else {
                        GfroerliMapAnnotationPin(location: location)
                            .onTapGesture {
                                zoom(to: location.coordinates!.coordinate)
                            }
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("Picker", selection: $filter) {
                            Text("All").tag(0)
                            Text("Active").tag(1)
                        }
                    } label: {
                        Label("Sort", systemImage: filter == 0 ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
                
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                guard !locationsViewModel.allLocations.isEmpty else {
                    return
                }
                withAnimation {
                    filterChanged()
                }
            }
            .onChange(of: filter, perform: { newValue in
                withAnimation {
                    filterChanged()
                }
            })
        }
    }
    
    // MARK: - Private Functions
    
    private func filterChanged() {
        switch filter {
        case 0:
            region = locationsViewModel.mapRegionAll
        case 1:
            region = locationsViewModel.mapRegionActive
        default:
            region = locationsViewModel.mapRegionAll
        }
    }
    
    private func annotationLocations() -> [Location] {
        switch filter {
        case 0:
            return locationsViewModel.allLocations
        case 1:
            return  locationsViewModel.activeLocations
        default:
            return locationsViewModel.allLocations
        }
    }
    
    private func zoom(to coordinates: CLLocationCoordinate2D) {
        withAnimation {
            region = MKCoordinateRegion(center: coordinates, latitudinalMeters: config.zoomedMapSpan, longitudinalMeters: config.zoomedMapSpan)
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
