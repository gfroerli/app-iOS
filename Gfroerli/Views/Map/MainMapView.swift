//
//  MainMapView.swift
//  Gfroerli
//
//  Created by Marc on 23.12.2025.
//

import ClusterMapSwiftUI
import Foundation
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
                            withAnimation {
                                viewModel.position = .region(MKCoordinateRegion(
                                    center: cluster.coordinate,
                                    latitudinalMeters: 20000.0,
                                    longitudinalMeters: 20000.0
                                ))
                            } completion: {
                                viewModel.selectedLocation = nil
                            }
                        }
                }
                .annotationTitles(.hidden)
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapPitchToggle()
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
