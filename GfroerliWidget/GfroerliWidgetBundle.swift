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
    let kind = "GfroerliWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SingleLocationWidgetConfigurationIntent.self,
            provider: SingleLocationWidgetTimelineProvider()
        ) { entry in
            SingleLocationWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SingleLocationWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .previewIntent)
}
