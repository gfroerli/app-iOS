//
//  SensorOverviewMap.swift
//  iOS
//
//  Created by Marc Kramer on 03.12.20.
//

import SwiftUI
import MapKit

struct SensorOverviewMap: View {
    
    @ObservedObject var sensorVM: SingleSensorViewModel
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.798449, longitude: 8.231879),
        span: MKCoordinateSpan(latitudeDelta: 3.5, longitudeDelta: 3.5))
    
    @State var originalRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.798449, longitude: 8.231879),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Location")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    region = originalRegion
                } label: {
                    Image(systemName: "scope")
                        .font(.title2)
                }.disabled(sensorVM.loadingState != .loaded)
            }.padding([.top, .horizontal])
            
            if sensorVM.loadingState == .loaded {
                ZStack(alignment: .bottom) {
                    
                    Map(coordinateRegion: $region, annotationItems: [sensorVM.sensor!]) { mark in
                        MapMarker(coordinate: CLLocationCoordinate2D(
                            latitude: mark.latitude!,
                            longitude: mark.longitude!)
                        )
                    }.frame(minHeight: 300)
                    
                    HStack {
                        Button {
                            openMaps()
                        } label: {
                            Label("Directions", systemImage: "car.fill")
                        }
                        .padding(10)
                        .background(Material.thick)
                        .cornerRadius(10)
                    }
                    .padding()
                    .onAppear(perform: initiateMapView)
                }
            } else {
                LoadingView()
            }
        }
    }
    
    /// Opens AppleMaps to provide directions
    private func openMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: sensorVM.sensor!.latitude!,
            longitude: sensorVM.sensor!.longitude!
        )
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = sensorVM.sensor!.sensorName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    ///  Sets region of map when sensor is successfully loaded
    private func initiateMapView() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: sensorVM.sensor!.latitude!,
                longitude: sensorVM.sensor!.longitude!),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        originalRegion = region
    }
}

struct SensorOverviewMap_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewMap(sensorVM: SingleSensorViewModel()).makePreViewModifier()
    }
}
