//
//  GfroerliWidget.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

struct GfroerliWidgetEntryView: View {
    var entry: SingleLocationWidgetTimelineProvider.Entry

    var body: some View {
        VStack {
            if let location = entry.configuration.location {
                Text(String(location.name))
                Text(String(location.tempString))
                
                Text(String(location.lastTempDateString))
                Text(String(location.id))
            }
            Text("No data")
        }
    }
}

struct GfroerliWidget: Widget {
    let kind = "GfroerliWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SingleLocationWidgetConfigurationIntent.self,
            provider: SingleLocationWidgetTimelineProvider()
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
