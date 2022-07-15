//
//  MapView.swift
//  MapView
//
//  Created by Marc Kramer on 17.07.21.
//

import SwiftUI
import MapKit
import UIKit
import CoreLocationUI
import CoreLocation

struct MapView: View {
    @ObservedObject var sensorsVm: SensorListViewModel
        
    @State var selectedSensor: Sensor?
    @StateObject var locationManager = ObservableLocationManager()
    
    var body: some View {
        NavigationView {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: sensorsVm.sensorArray) { sensor in
                MapAnnotation(coordinate: sensor.coordinates) {
                    
                    if locationManager.region.span.latitudeDelta <= 0.15 {
                        
                        NavigationLink {
                            SensorOverView(sensorID: sensor.id, sensorName: sensor.sensorName)
                        } label: {
                            HStack {
                                Text(sensor.sensorName)
                                Text(makeTemperatureString(double: sensor.latestTemp, precision: 2))
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(8)
                            .boxStyle()
                        }
                        .buttonStyle(.plain)
                    
                    } else {
                        
                        Image(systemName: "mappin.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .red)
                            .font(.system(size: 30))
                            .onTapGesture {
                                selectedSensor = sensor
                                zoomToPin(sensor: sensor)
                            }
                    }
                }
            }
        }.edgesIgnoringSafeArea(.top)
        }
        
        
    }
    
    func zoomToPin(sensor: Sensor) {
        withAnimation {
            locationManager.region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            locationManager.region.center = sensor.coordinates
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
