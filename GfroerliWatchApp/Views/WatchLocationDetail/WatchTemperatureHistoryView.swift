//
//  WatchTemperatureHistoryView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 30.05.2024.
//

import Charts
import SwiftUI

struct WatchTemperatureHistoryView: View {
    private let locationID: Int

    init(locationID: Int) {
        self.locationID = locationID
    }
    
    var body: some View {
        VStack {
            TabView {
                WatchTemperatureHistoryChartView(locationID: locationID, timeSpan: .day)
                    .tag(0)
                WatchTemperatureHistoryChartView(locationID: locationID, timeSpan: .week)
                    .tag(1)
                WatchTemperatureHistoryChartView(locationID: locationID, timeSpan: .month)
                    .tag(2)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .tabViewStyle(.page)
        }
      
        .navigationTitle("temperature_history_view_title")
    }
}

struct WatchTemperatureHistoryChartView: View {
    private let locationID: Int
    private let chartVM: TemperatureChartViewModel
    
    init(locationID: Int, timeSpan: ChartTimeSpan) {
        self.locationID = locationID
        self.chartVM = TemperatureChartViewModel(locationID: locationID, timeSpan: timeSpan)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            switch chartVM.timeSpan {
            case .day:
                Text("temperature_history_view_picker_day")
                    .bold()
            case .week:
                Text("temperature_history_view_picker_week")
                    .bold()
            case .month:
                Text("temperature_history_view_picker_month")
                    .bold()
            }
            LocationTemperatureChartView(locationID: locationID, chartVM: chartVM)
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(4)
        }
    }
}

struct LocationTemperatureChartView: View {
    
    let locationID: Int
    let chartVM: TemperatureChartViewModel
    
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
        }
        .chartForegroundStyleScale([
            NSLocalizedString("history_graph_view_legend_minimum_short", comment: ""): .blue,
            NSLocalizedString("history_graph_view_legend_average_short", comment: ""): .green,
            NSLocalizedString("history_graph_view_legend_maximum_short", comment: ""): .red,
        ])
        .chartLegend(position: .bottom, alignment: .center, spacing: 4)
        .chartYScale(domain: chartVM.lowestTemp...chartVM.highestTemp)
    }
}
