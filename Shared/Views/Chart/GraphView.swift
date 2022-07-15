//
//  GraphView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct GraphView: View {
    
    var nrOfLines: Int
    @Binding var timeFrame: TimeFrame
    @State var minValue = 0.0
    @State var maxValue = 30.0
    @State var totalSteps = 7
    @State var steps = [Int]()
    
    @Binding var selectedIndex: Int
    @Binding var zoomed: Bool
    @State var minimums = [Double]()
    @State var averages = [Double]()
    @State var maximums = [Double]()
    
    @Binding var showIndicator: Bool
    
    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    
    var body: some View {
        VStack {
            HStack {
                YLabelsView(nrOfLines: nrOfLines, max: $maxValue, min: $minValue)
                
                ChartView(
                    temperatureAggregationsVM:
                        temperatureAggregationsVM,
                    nrOfLines: nrOfLines,
                    timeFrame: $timeFrame,
                    minValue: $minValue,
                    maxValue: $maxValue,
                    totalSteps: $totalSteps,
                    steps: $steps,
                    minimums: $minimums,
                    averages: $averages,
                    maximums: $maximums,
                    selectedIndex: $selectedIndex,
                    showIndicator: $showIndicator
                )
            }.padding(1).clipped()
            
            HStack {
                Text("00.0°C").hidden()
                
                XLabelsView(
                    temperatureAggregationsVM: temperatureAggregationsVM,
                    timeFrame: $timeFrame,
                    totalSteps: $totalSteps
                )
            }
            
        }
        .padding()
        .task {
            await temperatureAggregationsVM.loadDays()
            await temperatureAggregationsVM.loadWeek()
            await temperatureAggregationsVM.loadMonth()
            
            setValues()
        }
        .onChange(of: timeFrame, perform: {_ in setValues()})
        .onChange(of: temperatureAggregationsVM.minimumsDay, perform: {_ in setValues()})
        .onChange(of: temperatureAggregationsVM.minimumsWeek, perform: {_ in setValues()})
        .onChange(of: temperatureAggregationsVM.minimumsMonth, perform: {_ in setValues()})
        .onChange(of: zoomed, perform: { _ in setMinMax()})
    }
    
    func setValues() {
        if timeFrame == .day {
            
            totalSteps = 23
            steps = temperatureAggregationsVM.stepsDay
            minimums = temperatureAggregationsVM.minimumsDay
            maximums = temperatureAggregationsVM.maximumsDay
            averages = temperatureAggregationsVM.averagesDay
        } else if timeFrame == .week {
            
            totalSteps = 6
            steps = temperatureAggregationsVM.stepsWeek
            minimums = temperatureAggregationsVM.minimumsWeek
            maximums = temperatureAggregationsVM.maximumsWeek
            averages = temperatureAggregationsVM.averagesWeek
            
        } else if timeFrame == .month {
            
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: temperatureAggregationsVM.startDateMonth)!
            totalSteps = range.count-1
            steps = temperatureAggregationsVM.stepsMonth
            minimums = temperatureAggregationsVM.minimumsMonth
            maximums = temperatureAggregationsVM.maximumsMonth
            averages = temperatureAggregationsVM.averagesMonth
        }
        setMinMax()
    }
    
    func setMinMax() {
        if zoomed {
            var allValues = [Double]()
            allValues += maximums
            allValues += minimums
            allValues += averages
            minValue = allValues.min()?.rounded(.down) ?? 0.0
            maxValue = allValues.max()?.rounded(.up) ?? 30.0
        } else {
            minValue = 0.0
            maxValue = 30.0
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(
            nrOfLines: 5,
            timeFrame: .constant(.week),
            selectedIndex: .constant(1),
            zoomed: .constant(false),
            showIndicator: .constant(false),
            temperatureAggregationsVM: TemperatureAggregationsViewModel()
        ).makePreViewModifier()
    }
}
