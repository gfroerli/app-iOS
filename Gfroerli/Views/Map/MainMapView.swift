//
//  MainMapView.swift
//  Gfroerli
//
//  Created by Marc on 23.12.2025.
//

import ClusterMapSwiftUI
import Foundation
import GfroerliBusinessMocks
import MapKit
import SwiftUI

struct MainMapView: View {
    // MARK: - Private properties

    @Binding var viewModel: MainMapViewModel
    @Binding var navigationPath: [Int]

    // MARK: - Body
    
    var body: some View {
        Map(
            position: $viewModel.position,
            selection: $viewModel.selectedLocation
        ) {
            ForEach(viewModel.annotations) { mapLocation in
                Annotation("", coordinate: mapLocation.coordinate) {
                    LocationAnnotation(location: mapLocation, expanded: $viewModel.expandAnnotations)
                        .id(mapLocation)
                        .onTapGesture {
                            viewModel.selectedLocation = mapLocation
                        }
                }
                .annotationTitles(.hidden)
                .tag(mapLocation)
            }
            
            ForEach(viewModel.clusters) { cluster in
                Annotation("", coordinate: cluster.coordinate) {
                    ClusterAnnotation(locations: cluster.locations)
                        .onTapGesture {
                            viewModel.selectedLocation = nil
                            viewModel.zoom(into: cluster)
                        }
                }
                .annotationTitles(.hidden)
            }

            UserAnnotation()
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .overlay(alignment: .bottomTrailing) {
            if viewModel.canFocusOnUserLocation {
                Button {
                    viewModel.focusOnUserAndClosestLocations()
                } label: {
                    Image(systemName: "location.fill")
                        .imageScale(.large)
                        .padding(12)
                }
                .glassEffect(.regular)
                .padding()
                .accessibilityLabel("main_view_locate_label")
            }
        }
        .onAppear {
            viewModel.requestUserLocation()
        }
        .readSize { newValue in
            viewModel.mapSize = newValue
        }
        .onMapCameraChange { context in
            viewModel.currentRegion = context.region
        }
        .onMapCameraChange(frequency: .onEnd) { _ in
            Task.detached { await viewModel.reloadAnnotations() }
        }
        
        .onChange(of: viewModel.selectedLocation) { _, newSelection in
            guard let newSelection else {
                return
            }
            
            if viewModel.expandAnnotations {
                navigationPath.append(newSelection.id)
                viewModel.selectedLocation = nil
            }
            else {
                withAnimation {
                    viewModel.position = .region(MKCoordinateRegion(
                        center: newSelection.coordinate,
                        latitudinalMeters: 5000.0,
                        longitudinalMeters: 5000.0
                    ))
                } completion: {
                    viewModel.selectedLocation = nil
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = MainMapViewModel(allLocationsManager: BusinessAllLocationsManagerMock())

    MainMapView(viewModel: $viewModel, navigationPath: .constant([]))
        .onAppear {
            Task {
                try? await viewModel.loadLocations()
            }
        }
}
