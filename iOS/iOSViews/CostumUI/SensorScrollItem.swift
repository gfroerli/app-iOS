//
//  SensorScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import SwiftUI
import MapKit

struct SensorScrollItem: View {
    
    var sensor: Sensor
    @State var region: MKCoordinateRegion
    
    init(sensor: Sensor) {
        self.sensor = sensor
        _region = State(initialValue: MKCoordinateRegion(
            center: sensor.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Map(coordinateRegion: $region, interactionModes: [])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(sensor.sensorName)
                        .font(.headline)
                    Text(sensor.sensorCaption)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer(minLength: 35)
                
                VStack(alignment: .trailing) {
                    Text(makeTemperatureString(double: sensor.latestTemp))
                        .font(.headline)
                    Text(sensor.lastTempTime!, format: .relative(presentation: .named))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding([.horizontal, .bottom])
            .lineLimit(2)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.tertiary, lineWidth: 0.2)
        )
        .shadow(color: .black.opacity(0.1), radius: 10)
        .padding([.horizontal, .bottom])
        .padding(.top, 2)
    }
}

struct SensorScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
