//
//  HistoryGraphView.swift
//  gfroerli
//
//  Created by Marc on 06.01.23.
//

import Charts
import SwiftUI

struct HistoryGraphView: View {
    
    @ObservedObject var hourlyVM: TemperaturesViewModel
    @Binding var zoomed: Bool
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
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(hourlyVM.averageTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("average", $0.value),
                        series: .value("Average", "avg")
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(hourlyVM.highestTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("high", $0.value),
                        series: .value("Highest", "high")
                    )
                    .foregroundStyle(.red)
                    .interpolationMethod(.catmullRom)
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
            .chartYScale(domain: zoomed ? hourlyVM.zoomedYAxisMinValue...hourlyVM.zoomedYAxisMaxValue : 0...30)
            .frame(minHeight: 250)
            
            HStack {
                Button {
                    withAnimation {
                        hourlyVM.stepBack()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.bordered)
                Spacer()
                
                Text(hourlyVM.xAxisLabel)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    hourlyVM.stepForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.bordered)
                .disabled(hourlyVM.isAtMostRecentInterval)
            }
            .buttonBorderShape(.capsule)
        }
    }

    private func domain() -> any PositionScaleRange {
        return (0...1 as? (any PositionScaleRange))!
    }
}

struct HourlyHistoryGraphView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryGraphView(
            hourlyVM: TemperaturesViewModel(locationID: 1, interval: .day, date: Date.now),
            zoomed: .constant(false)
        )
    }
}
