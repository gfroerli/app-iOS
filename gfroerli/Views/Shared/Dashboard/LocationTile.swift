//
//  SwiftUIView.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import GfroerliAPI
import MapKit
import SwiftUI

struct LocationTile: View {
    
    typealias config = AppConfiguration.Dashboard

    @Environment(\.colorScheme) var colorScheme
    @State var region: MKCoordinateRegion
    
    var location: Location
    
    // MARK: Lifecylce

    init(location: Location) {
        self.location = location
        _region = State(
            initialValue: MKCoordinateRegion(
                center: location.coordinates!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            Map(coordinateRegion: $region, interactionModes: [])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.headline)
                    Text(location.description)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer(minLength: 35)
                
                VStack(alignment: .trailing) {
                    Text(location.latestTemperatureString)
                        .font(.headline)
                    
                    Text(location.lastTemperatureDateString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2, reservesSpace: true)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .frame(maxWidth: .infinity, idealHeight: config.gridTileHeight)
        .defaultBoxStyle()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LocationTile(location: Location.exampleLocation())
    }
}
