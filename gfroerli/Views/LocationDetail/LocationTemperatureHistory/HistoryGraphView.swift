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
            ZStack {
                if !vm.hasDataPoints {
                    Text("No Data available")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(5)
                        .background(
                            .ultraThickMaterial,
                            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                }
                Chart {
                    ForEach(vm.lowestTemperatures, id: \.id) {
                        LineMark(
                            x: .value("date", $0.measurementDate),
                            y: .value("low", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("Lowest", "low")
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                    }
                    
                    ForEach(vm.averageTemperatures) {
                        LineMark(
                            x: .value("date", $0.measurementDate),
                            y: .value("average", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("Average", "avg")
                        )
                        .foregroundStyle(.green)
                        .interpolationMethod(.catmullRom)
                    }
                    
                    ForEach(vm.highestTemperatures) {
                        LineMark(
                            x: .value("date", $0.measurementDate),
                            y: .value("highest", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("Highest", "high")
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom)
                    }
                    
                    ForEach(vm.placeholderTemperatures) {
                        LineMark(
                            x: .value("date", $0.measurementDate),
                            y: .value("placeholder", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("Placeholder", "placeholder")
                        )
                        .foregroundStyle(.clear)
                    }
                }
                .chartYScale(domain: zoomed ? vm.zoomedYAxisMinValue...vm.zoomedYAxisMaxValue : 0...30)
                .frame(minHeight: 250)
            }
            .onChange(of: vm.averageTemp) { _ in
                animate()
            }
            .onAppear {
                animate()
            }
            
            HStack {
                Button {
                    vm.stepBack()
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
    
    private func animate() {
        for (index, _) in vm.highestTemperatures.enumerated() {
            withAnimation {
                vm.lowestTemperatures[index].animate = true
                vm.averageTemperatures[index].animate = true
                vm.highestTemperatures[index].animate = true
            }
        }
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
