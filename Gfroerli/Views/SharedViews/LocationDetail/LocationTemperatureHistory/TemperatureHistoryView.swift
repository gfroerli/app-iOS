//
//  TemperatureHistoryView.swift
//  gfroerli
//
//  Created by Marc on 09.09.22.
//

import Charts
import GfroerliBackend
import SwiftUI

struct TemperatureHistoryView: View {
    typealias config = AppConfiguration

    private var locationID: Int

    @StateObject var hourlyVM: TemperaturesViewModel
    @StateObject var weeklyVM: TemperaturesViewModel
    @StateObject var monthlyVM: TemperaturesViewModel

    @State private var currentSelection: ChartSpan = .month
    @State private var hoveringIndex: Int?
    @State private var zoomed = true

    // MARK: - Lifecycle

    init(locationID: Int) {
        self.locationID = locationID
        _hourlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .day, date: Date.now))
        _weeklyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .week, date: Date.now))
        _monthlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .month, date: Date.now))
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if hoveringIndex != nil {
                    Text("general_space")
                        .font(.title2)
                        .bold()

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
                    Text("temperature_history_view_title")
                        .font(.title2)
                        .bold()

                    Spacer()

                    // Used to make view not jump
                    VStack {
                        Text("general_space")
                        Text("general_space")
                    }

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

// MARK: - Preview

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(locationID: 1)
    }
}

// MARK: - Subviews

struct TopGraphSummaryView: View {
    @ObservedObject var vm: TemperaturesViewModel

    @Binding var currentSelection: ChartSpan
    @Binding var currentIndex: Int?

    var body: some View {
        if let currentIndex, currentIndex < vm.lowestTemperatures.count {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
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
