//
//  MapView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import GfroerliAPI
import MapKit
import SwiftUI

struct LocationMapView: View {
    typealias config = AppConfiguration.MapView
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var region = config.defaultRegion
    
    @Binding var filter: Int
    @Binding var searchDetent: PresentationDetent
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: annotationLocations()) { location in
                
                MapAnnotation(coordinate: location.coordinates?.coordinate ?? config.defaultCoordinates.coordinate) {
                    if location.coordinates == nil {
                        EmptyView()
                    }
                    else if region.span.latitudeDelta <= 0.1 {
                        Button {
                            navigationModel.navigationPath.append(location)
                            
                        } label: {
                            GfroerliMapAnnotation(location: location)
                        }
                        .buttonStyle(.plain)
                    }
                    else {
                        GfroerliMapAnnotationPin(location: location)
                            .onTapGesture {
                                zoom(to: location.coordinates!.coordinate)
                            }
                    }
                }
            }
            
            .onTapGesture {
                searchDetent = .fraction(0.1)
            }
            
            .onChange(of: filter, perform: { _ in
                withAnimation {
                    filterChanged()
                }
            })
            
            .onChange(of: locationsViewModel.allLocations, perform: { _ in
                filterChanged()
            })
            
            .ignoresSafeArea(.all, edges: .bottom)
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
            return locationsViewModel.activeLocations
        default:
            return locationsViewModel.allLocations
        }
    }
    
    private func zoom(to coordinates: CLLocationCoordinate2D) {
        searchDetent = .fraction(0.1)
        
        withAnimation {
            region = MKCoordinateRegion(
                center: coordinates,
                latitudinalMeters: config.zoomedMapSpan,
                longitudinalMeters: config.zoomedMapSpan
            )
        }
    }
}

// MARK: - Preview

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView(filter: .constant(1), searchDetent: .constant(.medium))
    }
}
