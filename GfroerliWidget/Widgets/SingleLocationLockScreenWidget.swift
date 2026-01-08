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
        #if os(iOS)
            .supportedFamilies([
                .accessoryInline,
                .accessoryRectangular,
                .accessoryCircular,
            ])
        #elseif os(watchOS)
            .supportedFamilies([
                .accessoryCircular,
                .accessoryCorner,
                .accessoryInline,
                .accessoryRectangular,
            ])
        #endif
    }
}

#if os(iOS)

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

    #Preview(as: .accessoryCircular) {
        SingleLocationLockScreenWidget()
    } timeline: {
        LocationEntry(date: .now, configuration: .previewIntent)
    }
#else

    #Preview(as: .accessoryCircular) {
        SingleLocationLockScreenWidget()
    } timeline: {
        LocationEntry(date: .now, configuration: .previewIntent)
    }

    #Preview(as: .accessoryCorner) {
        SingleLocationLockScreenWidget()
    } timeline: {
        LocationEntry(date: .now, configuration: .previewIntent)
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
#endif
