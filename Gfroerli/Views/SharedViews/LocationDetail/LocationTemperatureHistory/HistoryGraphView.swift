//
//  HistoryGraphView.swift
//  gfroerli
//
//  Created by Marc on 06.01.23.
//

import Charts
import GfroerliBackend
import SwiftUI

struct HistoryGraphView: View {
    @ObservedObject var vm: TemperaturesViewModel

    @Binding var zoomed: Bool
    @Binding var hoveringIndex: Int?

    // MARK: - Body

    var body: some View {
        VStack {
            ZStack {
                if !vm.hasDataPoints {
                    Text("history_graph_view_no_data_label")
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
                            x: .value("history_graph_view_legend_date", $0.measurementDate),
                            y: .value("history_graph_view_legend_minimum", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("history_graph_view_legend_minimum", "history_graph_view_legend_minimum")
                        )
                        .foregroundStyle(.blue.gradient)
                        .interpolationMethod(.catmullRom)
                    }

                    ForEach(vm.averageTemperatures) {
                        LineMark(
                            x: .value("history_graph_view_legend_date", $0.measurementDate),
                            y: .value("history_graph_view_legend_average", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("history_graph_view_legend_average", "history_graph_view_legend_average")
                        )
                        .foregroundStyle(.green.gradient)
                        .interpolationMethod(.catmullRom)
                    }

                    ForEach(vm.highestTemperatures) {
                        LineMark(
                            x: .value("history_graph_view_legend_date", $0.measurementDate),
                            y: .value("history_graph_view_legend_maximum", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("history_graph_view_legend_maximum", "history_graph_view_legend_maximum")
                        )
                        .foregroundStyle(.red.gradient)
                        .interpolationMethod(.catmullRom)
                    }

                    ForEach(vm.placeholderTemperatures) {
                        LineMark(
                            x: .value("general_space", $0.measurementDate),
                            y: .value("general_space", $0.animate ? $0.value : vm.averageTemp),
                            series: .value("general_space", "general_space")
                        )
                        .foregroundStyle(.clear)
                        .accessibilityHidden(true)
                    }
                    if let hoveringIndex, hoveringIndex < vm.averageTemperatures.count {
                        RuleMark(x: .value("", vm.averageTemperatures[hoveringIndex].measurementDate))
                            .foregroundStyle(.gray.gradient)
                    }
                }
                .chartForegroundStyleScale([
                    NSLocalizedString("history_graph_view_legend_minimum", comment: ""): .blue,
                    NSLocalizedString("history_graph_view_legend_average", comment: ""): .green,
                    NSLocalizedString("history_graph_view_legend_maximum", comment: ""): .red,
                ])
                .chartLegend(position: .bottom, alignment: .center, spacing: 10)
                .chartYScale(domain: zoomed ? vm.zoomedYAxisMinValue...vm.zoomedYAxisMaxValue : 0...30)

                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        hoveringIndex = findIndex(location: value.location, proxy: proxy, geometry: geo)
                                    }
                                    .onEnded { _ in hoveringIndex = nil }
                            )
                    }
                }
                .frame(minHeight: 250)
            }
            .onChange(of: vm.averageTemp) {
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
                .accessibilityIdentifier("HistoryGraphView_Back")
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

    // MARK: - Private Functions

    private func animate() {
        for (index, _) in vm.highestTemperatures.enumerated() {
            withAnimation {
                vm.lowestTemperatures[index].animate = true
                vm.averageTemperatures[index].animate = true
                vm.highestTemperatures[index].animate = true
            }
        }
    }

    private func findIndex(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Int? {
        guard let plotFrame = proxy.plotFrame else {
            return nil
        }
        
        let relativeXPosition = location.x - geometry[plotFrame].origin.x

        if let date = proxy.value(atX: relativeXPosition) as Date? {
            var minDistance: TimeInterval = .infinity
            var index: Int?
            for dataIndex in vm.averageTemperatures.indices {
                let nthDataDistance = vm.averageTemperatures[dataIndex].measurementDate.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index {
                return index
            }
        }
        return nil
    }
}

// MARK: - Preview

struct HourlyHistoryGraphView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryGraphView(
            vm: TemperaturesViewModel(locationID: 1, interval: .day, date: Date.now),
            zoomed: .constant(false),
            hoveringIndex: .constant(nil)
        )
    }
}
