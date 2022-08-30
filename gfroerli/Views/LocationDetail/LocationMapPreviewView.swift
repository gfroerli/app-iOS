//
//  LocationMapPreviewView.swift
//  gfroerli
//
//  Created by Marc on 30.08.22.
//

import SwiftUI
import MapKit
import GfroerliAPI

struct LocationMapPreviewView: View {
    
    typealias Config = AppConfiguration.MapPreviewView
    @Binding var location: Location
    @State var hasLocation = false
    @State var region: MKCoordinateRegion
    
    init(location: Binding<Location>) {
        self._location = Binding(projectedValue: location)
        self._region = State(wrappedValue: Config.defaultRegion)
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Map")
                    .font(.title).bold()
                
                Spacer()
                
                Button {
                    withAnimation {
                        setLocation()
                    }
                } label: {
                    Image(systemName: "mappin.and.ellipse").font(.title2)
                }
                .disabled(!hasLocation)
                .buttonStyle(.bordered)
                .clipShape(Circle())
                
            }
            .padding([.top, .horizontal])
            
            ZStack {
                Map(coordinateRegion: $region, annotationItems: [location], annotationContent: { location in
                    MapMarker(coordinate: location.coordinates!.coordinate, tint: .blue)
                })
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .blur(radius: hasLocation ? 0 : 1)
                .disabled(!hasLocation)
                
                if !hasLocation {
                    Text("Location unavailable")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(4)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            
        }
        .onChange(of: location, perform: { newValue in
            setLocation()
        })
        .defaultBoxStyle()
    }
    
    // MARK: - Private Functions
    
    private func setLocation () {
        guard let coords = location.coordinates else {
            hasLocation = false
            region = Config.defaultRegion
            return
        }
        
        hasLocation = true
        region = MKCoordinateRegion(center: coords.coordinate, latitudinalMeters: Config.defaultMapSpan, longitudinalMeters: Config.defaultMapSpan)
    }
}

struct LocationMapPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapPreviewView(location: .constant(Location.exampleLocation()))
    }
}
