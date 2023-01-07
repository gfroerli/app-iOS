//
//  HistoryGraphView.swift
//  gfroerli
//
//  Created by Marc on 06.01.23.
//

import Charts
import SwiftUI

struct HistoryGraphView: View {
    
    @ObservedObject var vm: TemperaturesViewModel
    @Binding var zoomed: Bool

    var body: some View {
        VStack {
            Chart {
                ForEach(vm.lowestTemperatures, id: \.id) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("low", $0.value),
                        series: .value("Lowest", "low")
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(vm.averageTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("average", $0.value),
                        series: .value("Average", "avg")
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(vm.highestTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("high", $0.value),
                        series: .value("Highest", "high")
                    )
                    .foregroundStyle(.red)
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(vm.placeholderTemperatures) {
                    LineMark(
                        x: .value("date", $0.measurementDate),
                        y: .value("placeholder", $0.value),
                        series: .value("Placeholder", "placeholder")
                    )
                    .foregroundStyle(.clear)
                }
            }
            .chartYScale(domain: zoomed ? vm.zoomedYAxisMinValue...vm.zoomedYAxisMaxValue : 0...30)
            .frame(minHeight: 250)
            
            HStack {
                Button {
                    withAnimation {
                        vm.stepBack()
                    }
                } label: {
                    Image(systemName: "chevron.left").fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                Spacer()
                
                Text(vm.xAxisLabel)
                    .font(.callout).bold()
                
                Spacer()
                
                Button {
                    vm.stepForward()
                } label: {
                    Image(systemName: "chevron.right").fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                .disabled(vm.isAtMostRecentInterval)
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
            vm: TemperaturesViewModel(locationID: 1, interval: .day, date: Date.now),
            zoomed: .constant(false)
        )
    }
}
