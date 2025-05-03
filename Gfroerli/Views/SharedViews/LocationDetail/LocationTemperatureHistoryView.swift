//
//  LocationTemperatureChart.swift
//  Gfroerli
//
//  Created by Marc on 31.05.2024.
//

import Charts
import GfroerliBackend
import SwiftUI

struct LocationTemperatureHistoryView: View {
    private let locationID: Int
    var chartVM: TemperatureChartViewModel
    @State var timeSpan: ChartTimeSpan
    @State var rawSelectedDate: Date?
    
    @MainActor
    init(locationID: Int) {
        self.locationID = locationID
        self.timeSpan = .week
        self.chartVM = TemperatureChartViewModel(locationID: locationID, timeSpan: .week)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("temperature_history_view_title")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Picker(
                    "temperature_history_view_picker_title",
                    selection: $timeSpan
                ) {
                    Text("temperature_history_view_picker_day").tag(ChartTimeSpan.day)
                    Text("temperature_history_view_picker_week").tag(ChartTimeSpan.week)
                    Text("temperature_history_view_picker_month").tag(ChartTimeSpan.month)
                }
                
                Button {
                    withAnimation {
                        chartVM.zoomed.toggle()
                    }
                } label: {
                    if chartVM.zoomed {
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
            .opacity(rawSelectedDate != nil ? 0.0 : 1.0)
            
            LocationTemperatureChartView(locationID: locationID, chartVM: chartVM, rawSelectedDate: $rawSelectedDate)
                .frame(minHeight: 250)
            
            HStack {
                Button {
                    chartVM.reduceDate()
                } label: {
                    Image(systemName: "chevron.left").fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("HistoryGraphView_Back")
                Spacer()

                Text(chartVM.intervalLabel)
                    .font(.callout).bold()

                Spacer()

                Button {
                    chartVM.advanceDate()
                } label: {
                    Image(systemName: "chevron.right").fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                .disabled(chartVM.isAtMostRecentInterval)
            }
            .buttonBorderShape(.capsule)
        }
        .padding()
        .onChange(of: timeSpan) { _, newValue in
            chartVM.timeSpan = newValue
        }
        .defaultBoxStyle()
    }
}

struct LocationTemperatureChartView: View {
    
    let locationID: Int
    let chartVM: TemperatureChartViewModel
    @Binding var rawSelectedDate: Date?
    
    @MainActor
    var selectedTemperatureEntry: TemperatureEntry? {
        guard let rawSelectedDate else {
            return nil
        }
        return chartVM.temperatureEntry(for: rawSelectedDate)
    }
    
    var body: some View {
  
        Chart(chartVM.dataArray) { dataSeries in
            ForEach(dataSeries.values) {
                LineMark(
                    x: .value(
                        "history_graph_view_legend_date",
                        $0.measurementDate,
                        unit: chartVM.timeSpan.chartXUnit
                    ),
                    y: .value(dataSeries.id, $0.value),
                    series: .value("history_graph_view_legend_maximum", dataSeries.id)
                )
                .foregroundStyle(dataSeries.type.chartColor)
                .interpolationMethod(.catmullRom)
                .symbol {
                    if dataSeries.values.count == 1 {
                        Circle().frame(width: 6)
                            .foregroundColor(dataSeries.type.chartColor)
                    }
                    else {
                        Circle().frame(width: 0)
                            .foregroundColor(dataSeries.type.chartColor)
                    }
                }
            }
            
            if let selectedTemperatureEntry {
                RuleMark(
                    x: .value(
                        "history_graph_view_legend_selected",
                        selectedTemperatureEntry.min.measurementDate,
                        unit: chartVM.timeSpan.chartXUnit
                    )
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(
                    position: .top, spacing: -0,
                    overflowResolution: .init(
                        x: .fit(to: .chart),
                        y: .disabled
                    )
                ) {
                    LocationTemperatureChartLollipopView(chartVM: chartVM, tempEntry: selectedTemperatureEntry)
                }
            }
        }
        .chartForegroundStyleScale([
            NSLocalizedString("history_graph_view_legend_minimum", comment: ""): .blue,
            NSLocalizedString("history_graph_view_legend_average", comment: ""): .green,
            NSLocalizedString("history_graph_view_legend_maximum", comment: ""): .red,
        ])
        .chartLegend(position: .bottom, alignment: .center, spacing: 10)
        .chartXSelection(value: $rawSelectedDate)
        .chartYScale(domain: chartVM.zoomed ? chartVM.lowestTemp...chartVM.highestTemp : 0...30)
    }
}

struct LocationTemperatureChartLollipopView: View {
    let chartVM: TemperatureChartViewModel
    let tempEntry: TemperatureEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            switch chartVM.timeSpan {
            case .day:
                Text(
                    tempEntry.min.measurementDate
                        .formatted(.dateTime.day().month().hour().minute())
                ).font(.headline)
            case .week:
                Text(
                    tempEntry.min.measurementDate
                        .formatted(.dateTime.weekday(.wide).day().month())
                ).font(.headline)
            case .month:
                Text(
                    tempEntry.min.measurementDate
                        .formatted(.dateTime.day().month(.abbreviated))
                ).font(.headline)
            }
            Spacer()
            HStack {
                Image(systemName: "circle.fill")
                    .foregroundStyle(.red)
                Text("\(MeasurementUtils.shared.temperatureString(from: tempEntry.max.value))")
               
                Image(systemName: "circle.fill")
                    .foregroundStyle(.green)
                Text("\(MeasurementUtils.shared.temperatureString(from: tempEntry.avg.value))")
              
                Image(systemName: "circle.fill")
                    .foregroundStyle(.blue)
                Text("\(MeasurementUtils.shared.temperatureString(from: tempEntry.min.value))")
            }
            .font(.subheadline)
            .fixedSize()
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 0.5)
        }
    }
}

#Preview {
    LocationTemperatureHistoryView(locationID: 6)
        .padding()
}
