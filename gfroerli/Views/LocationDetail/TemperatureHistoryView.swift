//
//  TemperatureHistoryView.swift
//  gfroerli
//
//  Created by Marc on 09.09.22.
//

import Charts
import GfroerliAPI
import SwiftUI

struct TemperatureHistoryView: View {
    
    typealias config = AppConfiguration
    
    @ObservedObject var hourlyVM = HourlyTemperaturesViewModel()
    @Binding var location: Location?
    
    var body: some View {
        VStack {
            Chart {
                ForEach(hourlyVM.lowestTemperatures, id: \.id) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("low", $0.value),
                        series: .value("Lowest", "low")
                    )
                    .foregroundStyle(.blue)
                }
                
                ForEach(hourlyVM.averageTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("average", $0.value),
                        series: .value("Average", "avg")
                    )
                    .foregroundStyle(.green)
                }
                
                ForEach(hourlyVM.highestTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("high", $0.value),
                        series: .value("Highest", "high")
                    )
                    .foregroundStyle(.red)
                }
                
                ForEach(hourlyVM.placeholderTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("placeholder", $0.value),
                        series: .value("Placeholder", "placeholder")
                    )
                    .foregroundStyle(.clear)
                }
            }
        }
        
        .padding()
        .frame(height: 200)
        .task {
            do {
                
                guard let locationID = location?.id else {
                    return
                }
                
                try await hourlyVM.loadHourlyMeasurements(
                    locationID: locationID,
                    of: Date.now.addingTimeInterval(-86000)
                )
            }
            catch {
                // TODO: Error handling
                print("@2")
            }
        }
    }
}

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(location: .constant(Location.exampleLocation()))
    }
}
