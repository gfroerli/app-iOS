//
//  SingleSensorWithGraphProvider.swift
//  Gfror.li
//
//  Created by Marc on 13.04.21.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWithGraphProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SingleSensorWithGraphEntry {
        SingleSensorWithGraphEntry(
            date: Date(),
            device_id: "Placeholder",
            configuration: SingleSensorGraphIntent(),
            timeFrameValue: .day,
            sensor: nil,
            data: nil)
    }
    
    func getSnapshot(
        for configuration: SingleSensorGraphIntent,
        in context: Context,
        completion: @escaping (SingleSensorWithGraphEntry) -> Void) {
            
            let entry = SingleSensorWithGraphEntry(
                date: Date(),
                device_id: "1",
                configuration: configuration,
                timeFrameValue: configuration.timeFrame,
                sensor: testSensor1,
                data: nil)
            completion(entry)
        }
    
    func getTimeline(
        for configuration: SingleSensorGraphIntent,
        in context: Context,
        completion: @escaping (Timeline<SingleSensorWithGraphEntry>) -> Void) {
            var entries: [SingleSensorWithGraphEntry] = []
            let singleSensorVM = SingleSensorViewModel()
            let tempAggregVM = TemperatureAggregationsViewModel()
            
            let selectableSensor = configuration.sensor
            
            tempAggregVM.id = Int(configuration.sensor?.identifier ?? "1")!
            
            
            Task { await singleSensorVM.load(sensorId: Int(configuration.sensor?.identifier ?? "1")!)
                await tempAggregVM.loadDays()
                await tempAggregVM.loadWeek()
                await tempAggregVM.loadMonth()
            }
            
            // Wait for async/await
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let entry = SingleSensorWithGraphEntry(
                    date: Date(),
                    device_id: selectableSensor?.identifier ?? "",
                    configuration: configuration,
                    timeFrameValue: configuration.timeFrame,
                    sensor: singleSensorVM.sensor,
                    data: tempAggregVM
                )
                entries.append(entry)
                
                let timeline = Timeline(
                    entries: entries,
                    policy: .after(Calendar.current.date(byAdding: .minute, value: 10, to: Date())!)
                )
                
                completion(timeline)
            }
        }
}

struct SingleSensorWithGraphEntry: TimelineEntry {
    var date: Date
    let device_id: String // swiftlint:disable:this identifier_name
    let configuration: SingleSensorGraphIntent
    let timeFrameValue: TimeFrameValue
    let sensor: Sensor?
    let data: TemperatureAggregationsViewModel?
    
}
