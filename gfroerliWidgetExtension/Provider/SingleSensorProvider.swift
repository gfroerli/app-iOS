//
//  SingleSensorProvider.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SingleSensorEntry {
        SingleSensorEntry(
            date: Date(),
            device_id: "Placeholder",
            configuration: SingleSensorIntent(),
            sensor: testSensor1
        )
    }

    func getSnapshot(
        for configuration: SingleSensorIntent,
        in context: Context,
        completion: @escaping (SingleSensorEntry) -> Void) {

        let entry = SingleSensorEntry(
            date: Date(),
            device_id: "Placeholder",
            configuration: configuration,
            sensor: testSensor1
        )
            
        completion(entry)
    }

    func getTimeline(
        for configuration: SingleSensorIntent,
        in context: Context,
        completion: @escaping (Timeline<SingleSensorEntry>) -> Void) {
        
            var entries: [SingleSensorEntry] = []
        let singleSensorVM = SingleSensorViewModel()
        let selectableSensor = configuration.sensor

        Task {
            await singleSensorVM.load(sensorId: Int(configuration.sensor?.identifier ?? "0")!)
        }

        // Wait for async/await
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            let entry = SingleSensorEntry(
                date: Date(),
                device_id: selectableSensor?.identifier ?? "",
                configuration: configuration,
                sensor: singleSensorVM.sensor
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

struct SingleSensorEntry: TimelineEntry {
    var date: Date
    let device_id: String // swiftlint:disable:this identifier_name
    let configuration: SingleSensorIntent
    let sensor: Sensor?
}
