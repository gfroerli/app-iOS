//
//  GfroerliWidgetBundle.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftData
import SwiftUI
import WidgetKit

@main
struct GfroerliWidgetBundle: WidgetBundle {
    var body: some Widget {
        SingleLocationWidget()
    }
}

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
