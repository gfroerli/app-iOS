//
//  SensorOverviewLastMeasurementView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewLastMeasurementView: View {
    
    @ObservedObject var sensorVM: SingleSensorViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if sensorVM.loadingState == .loaded {
                
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading) {
                            Text("Latest")
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(makeTemperatureString(double: sensorVM.sensor!.latestTemp))
                                .font(.largeTitle)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                            Text(sensorVM.sensor!.lastTempTime!, format: .relative(presentation: .named))
                        }
                    }
                    Text("All time:")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Text("Highest:")
                        Spacer()
                        Text(makeTemperatureString(double: sensorVM.sensor!.maxTemp))
                    }
                    HStack {
                        Text("Average:")
                        Spacer()
                        Text(makeTemperatureString(double: sensorVM.sensor!.avgTemp))
                    }
                    HStack {
                        Text("Lowest:")
                        Spacer()
                        Text(makeTemperatureString(double: sensorVM.sensor!.minTemp))
                    }
                }
            
            } else {
                Text("Latest")
                    .font(.title)
                    .bold()
                LoadingView()
            }
        }
        .padding([.horizontal, .bottom])
        .padding(.top, 5)
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
