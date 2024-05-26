//
//  SingleLocationWidget.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 24.05.2024.
//

import AppIntents
import GfroerliBackend
import SwiftUI
import WidgetKit

struct SingleLocationWidget: Widget {
    let kind = "GfroerliSingleLocationWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SingleLocationWidgetConfigurationIntent.self,
            provider: SingleLocationWidgetTimelineProvider()
        ) { entry in
            SingleLocationWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_single_loc_display_name")
        .description("widget_single_loc_description")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SingleLocationWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .previewIntent)
}
