//
//  LocationMapPreviewView.swift
//  gfroerli
//
//  Created by Marc on 30.08.22.
//

import GfroerliAPI
import MapKit
import SwiftUI

struct LocationMapPreviewView: View {
    
    typealias Config = AppConfiguration.MapPreviewView
    @Binding var location: Location?
    @State var hasLocation = false
    @State var region: MKCoordinateRegion
    
    init(location: Binding<Location?>) {
        self._location = Binding(projectedValue: location)
        self._region = State(wrappedValue: Config.defaultRegion)
    }
    
    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text("location_map_preview_view_title")
                    .font(.title2).bold()
                
                Spacer()
                
                Button {
                    withAnimation {
                        setLocation()
                    }
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .fontWeight(.semibold)
                }
                .disabled(!hasLocation)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
            .padding(.vertical, AppConfiguration.General.verticalBoxPadding)

            ZStack {
                Map(
                    coordinateRegion: $region,
                    annotationItems: hasLocation ? [location!] : [],
                    annotationContent: { location in
                        MapMarker(
                            coordinate: location.coordinates?.coordinate ?? AppConfiguration.MapPreviewView
                                .defaultCoordinates.coordinate,
                            tint: .accentColor
                        )
                    }
                )
                .disabled(!hasLocation)
                
                if !hasLocation {
                    VStack { }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                    
                    Text("location_map_preview_view_unavailable")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(AppConfiguration.General.capsulePadding)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: AppConfiguration.General.capsuleRadius))
                }
            }
        }
        .frame(idealHeight: Config.mapHeight)
        .defaultBoxStyle()
        
        .onAppear {
            setLocation()
        }
        .onChange(of: location, perform: { _ in
            setLocation()
        })
    }
    
    // MARK: - Private Functions
    
    private func setLocation() {
        guard let coords = location?.coordinates else {
            hasLocation = false
            region = Config.defaultRegion
            return
        }
        
        hasLocation = true
        region = MKCoordinateRegion(
            center: coords.coordinate,
            latitudinalMeters: Config.defaultMapSpan,
            longitudinalMeters: Config.defaultMapSpan
        )
    }
}

struct LocationMapPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapPreviewView(location: .constant(Location.exampleLocation()))
    }
}
