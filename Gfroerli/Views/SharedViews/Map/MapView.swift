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

    @Environment(NavigationModel.self) var navigationModel
    @Environment(AllLocationsViewModel.self) var locationsViewModel

    @State private var showBigAnnotations = false
    @State private var position: MapCameraPosition = .automatic
    @State private var mapStyle: MapStyle = .standard
    @State private var selectedLocation: Location?

    // MARK: - Body

    var body: some View {
        Map(position: $position, selection: $selectedLocation) {
            ForEach(locationsViewModel.filteredLocations) { location in
                Annotation("", coordinate: location.coordinates?.coordinate ?? config.defaultCoordinates.coordinate) {
                    GfroerliMapAnnotation(zoomed: $showBigAnnotations, location: location)
                }
                .annotationTitles(.hidden)
                .tag(location)
            }
        }
        .mapStyle(mapStyle)
        .mapControls {
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .onMapCameraChange { context in
            showBigAnnotations = context.region.span.latitudeDelta <= 0.1
        }

        .onChange(of: selectedLocation) { _, newValue in
            guard let newValue else {
                return
            }
            if showBigAnnotations {
                navigationModel.navigationPath.append(newValue)
                selectedLocation = nil
            }
            else {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: newValue.coordinates!.coordinate,
                        latitudinalMeters: config.zoomedMapSpan,
                        longitudinalMeters: config.zoomedMapSpan
                    ))
                } completion: {
                    selectedLocation = nil
                }
            }
        }
        .onChange(of: locationsViewModel.isFilterActive) { _, _ in
            withAnimation {
                position = .automatic
            }
        }
    }
}

// MARK: - Preview

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
            .environment(AllLocationsViewModel())
    }
}
