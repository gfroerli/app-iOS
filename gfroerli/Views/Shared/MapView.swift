//
//  MapView.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(47.0, 8.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
