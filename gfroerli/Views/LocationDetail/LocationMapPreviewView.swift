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
    let location: Location
    @State var region: MKCoordinateRegion
    
    init(location: Location) {
        self.location = location
        
        guard let coords = location.coordinates else {
            self._region = State(wrappedValue: MKCoordinateRegion(center: Config.defaultCoordinates.coordinate, latitudinalMeters: Config.defaultMapSpan, longitudinalMeters: Config.defaultMapSpan))
            return
        }
        self._region = State(wrappedValue: MKCoordinateRegion(center: coords.coordinate, latitudinalMeters: Config.defaultMapSpan, longitudinalMeters: Config.defaultMapSpan))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Map")
                    .font(.title).bold()
                
                Spacer()
                
                Button {
                    withAnimation {
                        region = MKCoordinateRegion(center: Config.defaultCoordinates.coordinate, latitudinalMeters: Config.defaultMapSpan, longitudinalMeters: Config.defaultMapSpan)
                    }
                } label: {
                    Image(systemName: "scope").font(.title2)
                }

            }
                .padding([.top, .horizontal])
            Map(coordinateRegion: $region)
        }
        .defaultBoxStyle()
    }
}

struct LocationMapPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapPreviewView(location: Location.exampleLocation())
    }
}
