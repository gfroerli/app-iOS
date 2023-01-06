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

    var locationID: Int

    @StateObject var hourlyVM: HourlyTemperaturesViewModel
    
    init(locationID: Int) {
        self.locationID = locationID
        self._hourlyVM = StateObject(wrappedValue: HourlyTemperaturesViewModel(locationID: locationID, date: Date.now))
    }
    
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
            .padding(.bottom)
            
            HStack {
                Button {
                    withAnimation {
                        hourlyVM.stepDayBack()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button {
                    hourlyVM.stepDayForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!hourlyVM.isAtCurrentDate)
            }
        }
        
        .padding()
        .frame(height: 200)
    }
}

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(locationID: 1)
    }
}
