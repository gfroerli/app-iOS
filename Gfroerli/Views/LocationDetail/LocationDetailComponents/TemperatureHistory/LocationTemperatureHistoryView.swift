//
//  LocationTemperatureChart.swift
//  Gfroerli
//
//  Created by Marc on 31.05.2024.
//

import Charts
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
        self.chartVM = TemperatureChartViewModel(
            locationID: locationID,
            timeSpan: .week,
            measurementManager: AppDependencies.makeMeasurementManager()
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("temperature_history_view_title")
                    .font(.title3)
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
    
    /// Snaps a date to the start of its x-axis bucket (hour for the day view, day otherwise). Plotting the
    /// raw date on a continuous scale makes each point sit at the leading edge of its slot instead of
    /// being centered inside it (which is what the `unit:` binning of `PlottableValue` does).
    private func binStart(_ date: Date) -> Date {
        let calendar = Calendar.current
        switch chartVM.timeSpan.chartXUnit {
        case .hour:
            return calendar.dateInterval(of: .hour, for: date)?.start ?? date
        default:
            return calendar.startOfDay(for: date)
        }
    }

    var body: some View {

        Chart {
            // Min–max range drawn as a semi-transparent gradient band.
            ForEach(chartVM.band) { point in
                AreaMark(
                    x: .value("history_graph_view_legend_date", binStart(point.date)),
                    yStart: .value("history_graph_view_legend_minimum", point.min),
                    yEnd: .value("history_graph_view_legend_maximum", point.max)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.accentColor.opacity(0.2))
            }

            if let data = chartVM.data {
                // Average line on top of the band.
                ForEach(data.avg.values) { point in
                    LineMark(
                        x: .value("history_graph_view_legend_date", binStart(point.measurementDate)),
                        y: .value("history_graph_view_legend_average", point.value),
                        series: .value("history_graph_view_legend_average", data.avg.id)
                    )
                    .foregroundStyle(Color.accentColor)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .round))
                    .symbol {
                        if data.avg.values.count == 1 {
                            Circle().frame(width: 6)
                                .foregroundColor(Color.accentColor)
                        }
                        else {
                            Circle().frame(width: 0)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }

                // Transparent placeholder series: gives Charts a point at every bucket so the x-axis
                // grid adapts the same way it does elsewhere (a tick every couple of days / hours).
                ForEach(data.placeholder.values) { point in
                    LineMark(
                        x: .value("history_graph_view_legend_date", binStart(point.measurementDate)),
                        y: .value("placeholder", point.value),
                        series: .value("placeholder", data.placeholder.id)
                    )
                    .foregroundStyle(.clear)
                }
            }

            if let selectedTemperatureEntry {
                RuleMark(
                    x: .value("history_graph_view_legend_selected", binStart(selectedTemperatureEntry.date))
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
        .chartLegend(.hidden)
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
                    tempEntry.date
                        .formatted(.dateTime.day().month().hour().minute())
                ).font(.headline)
            case .week:
                Text(
                    tempEntry.date
                        .formatted(.dateTime.weekday(.wide).day().month())
                ).font(.headline)
            case .month:
                Text(
                    tempEntry.date
                        .formatted(.dateTime.day().month(.abbreviated))
                ).font(.headline)
            }
            Spacer()
            HStack(spacing: 10) {
                HStack(spacing: 3) {
                    Text("history_graph_view_legend_maximum_short")
                        .foregroundStyle(.secondary)
                    Text(tempEntry.maxString)
                }

                HStack(spacing: 3) {
                    Text("history_graph_view_legend_average_short")
                        .foregroundStyle(.secondary)
                    Text(tempEntry.avgString)
                }

                HStack(spacing: 3) {
                    Text("history_graph_view_legend_minimum_short")
                        .foregroundStyle(.secondary)
                    Text(tempEntry.minString)
                }
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
