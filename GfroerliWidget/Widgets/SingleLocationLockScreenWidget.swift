//
//  SingleLocationLockScreenWidget.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 24.05.2024.
//

import AppIntents
import GfroerliBackend
import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidget: Widget {
    let kind = "SingleLocationLockScreenWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SingleLocationWidgetConfigurationIntent.self,
            provider: SingleLocationWidgetTimelineProvider()
        ) { entry in
            SingleLocationLockScreenWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_single_loc_display_name")
        .description("widget_single_loc_description")
        .supportedFamilies([
            .accessoryInline,
            .accessoryRectangular,
        ])
    }
}

#Preview(as: .accessoryInline) {
    SingleLocationLockScreenWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .previewIntent)
}

#Preview(as: .accessoryRectangular) {
    SingleLocationLockScreenWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .previewIntent)
}
