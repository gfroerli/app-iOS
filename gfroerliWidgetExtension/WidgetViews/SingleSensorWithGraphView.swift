//
//  SingleSensorWithGraphView.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWithGraphView: View {

    var entry: SingleSensorWithGraphProvider.Entry
    var body: some View {
        ZStack {
            
            Wave(strength: 10, frequency: 8, offset: -300)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color("GfroerliLightBlue").opacity(0.4)]),
                        startPoint: .leading, endPoint: .trailing)
                ).offset(y: 40)
            
            Wave(strength: 10, frequency: 10, offset: -10.0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GfroerliLightBlue").opacity(0.5), Color.blue.opacity(0.4)]),
                        startPoint: .trailing, endPoint: .leading)
                )
                .offset(x: 0, y: 20)
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center/*@END_MENU_TOKEN@*/,
                    anchorZ: 0.0/*@END_MENU_TOKEN@*/,
                    perspective: 1.0/*@END_MENU_TOKEN@*/
                )
            
            if entry.data != nil {
                SensorWithGraphView(entry: entry)
            } else {
                VStack {
                    HStack {
                         if !Reachability.isConnectedToNetwork() {
                            Text("No internet connection.")
                                .foregroundColor(.white)
                        } else {
                            Text("Press and hold to select location")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "thermometer")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                    Spacer()
                }.padding()
            }
        }
        .background(Color("GfroerliDarkBlue"))
        .widgetURL(entry.sensor != nil ?
                   URL(string: "ch.coredump.gfroerli://home/\(entry.sensor!.id)") : URL(string: "ch.coredump.gfroerli"))
    }
}

struct SensorWithGraphView: View {
    @Environment(\.widgetFamily) var size
    
    var entry: SingleSensorWithGraphProvider.Entry
    
    var nrOfLines = 5
    @State var timeFrame: TimeFrame = .day
    @State var minValue = 0.0
    @State var maxValue = 30.0
    @State var totalSteps = 7
    @State var steps = [Int]()

    @State var selectedIndex = 0
    @State var showIndicator = false
    @State var zoomed = true
    @State var minimums = [Double]()
    @State var averages = [Double]()
    @State var maximums = [Double]()
    
    init(entry: SingleSensorWithGraphProvider.Entry){
        self.entry = entry
        setValues()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(entry.sensor!.sensorName)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.1)
                Spacer()
                Text(String(format: "%.1f", entry.sensor!.latestTemp!)+"°")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                Image(systemName: "thermometer").foregroundColor(.red).font(.system(size: 20))
            }
            
            HStack(spacing: 0) {
                Text("Measured at: ").font(.caption)
                    .foregroundColor(.white)
                Text(entry.sensor!.lastTempTime!, style: .time).font(.caption)
                    .foregroundColor(.white)
                Spacer()
            }
            
          
            VStack {
            ChartView(temperatureAggregationsVM: entry.data!,
                              nrOfLines: 5,
                              timeFrame: $timeFrame,
                              minValue: $minValue,
                              maxValue: $maxValue,
                              totalSteps: $totalSteps,
                              steps: .constant([0]),
                              minimums: $minimums,
                              averages: $averages,
                              maximums: $maximums,
                              selectedIndex: $selectedIndex,
                              showIndicator: $showIndicator)
                
            }.padding(.vertical, 10)
            
        }.padding()
    }
    
    func setValues() {
        guard let data = entry.data else {
            return
        }
        timeFrame = convertTimeFrame(frame: entry.timeFrameValue)
        
        if timeFrame == .day {
            
            totalSteps = 23
            steps = data.stepsDay
            minimums = data.minimumsDay
            maximums = data.maximumsDay
            averages = data.averagesDay
        } else if timeFrame == .week {
            
            totalSteps = 6
            steps = data.stepsWeek
            minimums = data.minimumsWeek
            maximums = data.maximumsWeek
            averages = data.averagesWeek
            
        } else if timeFrame == .month {
            
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: data.startDateMonth)!
            totalSteps = range.count-1
            steps = data.stepsMonth
            minimums = data.minimumsMonth
            maximums = data.maximumsMonth
            averages = data.averagesMonth
        }
        setMinMax()
    }
    
    func setMinMax() {
        
        var allValues = [Double]()
        allValues += maximums
        allValues += minimums
        allValues += averages
        minValue = allValues.min()?.rounded(.down) ?? 0.0
        maxValue = allValues.max()?.rounded(.up) ?? 30.0
        
    }
    
    func convertTimeFrame(frame: TimeFrameValue) -> TimeFrame{
        switch frame {
        case .unknown:
            return .day
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        }
    }
}

struct SingleSensorWithGraphWidget: Widget {
    let kind: String = "gfroerliWidgetExtensionGraph"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SingleSensorGraphIntent.self,
            provider: SingleSensorWithGraphProvider()) { entry in
                SingleSensorWithGraphView(entry: entry)
            }
            .supportedFamilies([.systemMedium, .systemLarge])
            .configurationDisplayName("Single Location with Graph")
            .description("Displays the temperature history of a location.")
    }
}

struct SingleSensorWithGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

