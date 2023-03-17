//
//  MapView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import GfroerliBackend
import MapKit
import SwiftUI

struct LocationMapView: View {
    typealias config = AppConfiguration.MapView
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var locationsViewModel: AllLocationsViewModel
    
    @State private var region = config.defaultRegion
    @State private var annotationLocations = [Location]()
    
    @Binding var filter: Int
    @Binding var searchDetent: PresentationDetent
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, annotationItems: annotationLocations) { location in
                MapAnnotation(coordinate: location.coordinates?.coordinate ?? config.defaultCoordinates.coordinate) {
                    Button {
                        didTapAnnotation(location: location)
                    } label: {
                        if location.coordinates == nil {
                            EmptyView()
                        }
                        else if region.span.latitudeDelta <= 0.1 {
                            GfroerliMapAnnotation(location: location)
                        }
                        else {
                            GfroerliMapAnnotationPin(location: location)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            VStack {
                Button {
                    withAnimation {
                        filterChanged()
                    }
                } label: {
                    Label("Zoom to all", systemImage: "arrow.up.left.and.arrow.down.right")
                        .labelStyle(.iconOnly)
                }
                .frame(width: 15, height: 15)
                .padding(8)
                .background(.background)
                .cornerRadius(10)
                .shadow(radius: 4)
                .accessibilityIdentifier("LocationMapView_Zoom")
            }
            .padding(10)
            
            .onChange(of: filter, perform: { _ in
                withAnimation {
                    filterChanged()
                }
            })
            .onChange(of: locationsViewModel.activeLocations, perform: { _ in
                region = locationsViewModel.mapRegionActive
                annotationLocations = locationsViewModel.activeLocations
                zoom(to: locationsViewModel.mapRegionActive.center, span: config.defaultMapSpan)
            })
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // MARK: - Private Functions
    
    private func filterChanged() {
        switch filter {
        case 0:
            region = locationsViewModel.mapRegionAll
            annotationLocations = locationsViewModel.allLocations
        case 1:
            region = locationsViewModel.mapRegionActive
            annotationLocations = locationsViewModel.activeLocations
        default:
            region = locationsViewModel.mapRegionAll
            annotationLocations = locationsViewModel.allLocations
        }
    }
    
    private func didTapAnnotation(location: Location) {
        if region.span.latitudeDelta <= 0.1 {
            navigationModel.navigationPath.append(location)
        }
        else {
            zoom(to: location.coordinates!.coordinate)
        }
    }
    
    private func zoom(to coordinates: CLLocationCoordinate2D, span: Double = config.zoomedMapSpan) {
        searchDetent = .fraction(0.1)
        
        withAnimation {
            region = MKCoordinateRegion(
                center: coordinates,
                latitudinalMeters: span,
                longitudinalMeters: span
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
