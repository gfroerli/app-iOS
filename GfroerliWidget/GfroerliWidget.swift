//
//  GfroerliWidget.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LocationEntry {
        LocationEntry(date: Date(), configuration: SelectLocationWidgetConfigurationIntent())
    }

    func snapshot(
        for configuration: SelectLocationWidgetConfigurationIntent,
        in context: Context
    ) async -> LocationEntry {
        LocationEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(
        for configuration: SelectLocationWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<LocationEntry> {
        var entries: [LocationEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = LocationEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct LocationEntry: TimelineEntry {
    let date: Date
    let configuration: SelectLocationWidgetConfigurationIntent
}

struct GfroerliWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
          
            Text(String(entry.configuration.location.name))
            Text(String(entry.configuration.location.tempString))

            Text(String(entry.configuration.location.lastTempDateString))
            Text(String(entry.configuration.location.id))
        }
    }
}

struct GfroerliWidget: Widget {
    let kind = "GfroerliWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectLocationWidgetConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            GfroerliWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    GfroerliWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .previewIntent)
}
