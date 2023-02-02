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

    @StateObject var hourlyVM: TemperaturesViewModel
    @StateObject var weeklyVM: TemperaturesViewModel
    @StateObject var monthlyVM: TemperaturesViewModel
    @State var currentSelection: ChartSpan = .day
    @State var hoveringIndex: Int?
    @State var zoomed = true
    
    init(locationID: Int) {
        self.locationID = locationID
        self
            ._hourlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .day, date: Date.now))
        self
            ._weeklyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .week, date: Date.now))
        self
            ._monthlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .month, date: Date.now))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("temperature_history_view_title")
                    .font(.title2)
                    .bold()
            
                Spacer()
                if hoveringIndex != nil {
                    switch currentSelection {
                    case .day:
                        TopGraphSummaryView(
                            vm: hourlyVM,
                            currentSelection: $currentSelection,
                            currentIndex: $hoveringIndex
                        )

                    case .week:
                        TopGraphSummaryView(
                            vm: weeklyVM,
                            currentSelection: $currentSelection,
                            currentIndex: $hoveringIndex
                        )

                    case .month:
                        TopGraphSummaryView(
                            vm: monthlyVM,
                            currentSelection: $currentSelection,
                            currentIndex: $hoveringIndex
                        )
                    }
                }
                else {
                    
                    // Used to make view not jump
                    VStack {
                        Text(" ")
                        Text(" ")
                    }.frame(maxWidth: 1)
                    
                    Picker("temperature_history_view_picker_title", selection: $currentSelection) {
                        Text("temperature_history_view_picker_day").tag(ChartSpan.day)
                        Text("temperature_history_view_picker_week").tag(ChartSpan.week)
                        Text("temperature_history_view_picker_month").tag(ChartSpan.month)
                    }
                    .fixedSize()
                    
                    Button {
                        zoomed = !zoomed
                    } label: {
                        if zoomed {
                            Image(systemName: "minus.magnifyingglass")
                                .fontWeight(.semibold)
                        }
                        else {
                            Image(systemName: "plus.magnifyingglass")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                }
            }

            switch currentSelection {
            case .day:
                HistoryGraphView(vm: hourlyVM, zoomed: $zoomed, hoveringIndex: $hoveringIndex)
            case .week:
                HistoryGraphView(vm: weeklyVM, zoomed: $zoomed, hoveringIndex: $hoveringIndex)
            case .month:
                HistoryGraphView(vm: monthlyVM, zoomed: $zoomed, hoveringIndex: $hoveringIndex)
            }
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(locationID: 1)
    }
}

struct TopGraphSummaryView: View {
   
    @ObservedObject var vm: TemperaturesViewModel
    
    @Binding var currentSelection: ChartSpan
    @Binding var currentIndex: Int?

    var body: some View {
        if let currentIndex {
            VStack(alignment: .trailing) {
                VStack {
                    switch currentSelection {
                    case .day:
                        Text(
                            vm.lowestTemperatures[currentIndex].measurementDate
                                .formatted(.dateTime.day().month().hour().minute())
                        )
                    case .week:
                        Text(
                            vm.lowestTemperatures[currentIndex].measurementDate
                                .formatted(.dateTime.weekday(.wide).day().month())
                        )
                    case .month:
                        Text(
                            vm.lowestTemperatures[currentIndex].measurementDate
                                .formatted(.dateTime.day().month(.abbreviated))
                        )
                    }
                }
                .bold()
                
                HStack {
                    Spacer()
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.blue)
                    Text(MeasurementUtils.shared.temperatureString(from: vm.lowestTemperatures[currentIndex].value))
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.green)
                    Text(MeasurementUtils.shared.temperatureString(from: vm.averageTemperatures[currentIndex].value))
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.red)
                    Text(MeasurementUtils.shared.temperatureString(from: vm.highestTemperatures[currentIndex].value))
                }
                .imageScale(.small)
                .lineLimit(1)
            }
        }
        else {
            EmptyView()
        }
    }
}
