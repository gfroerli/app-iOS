//
//  SingleLocationWidgetTimelineProvider.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

struct SingleLocationWidgetTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LocationEntry {
        LocationEntry(date: Date.now, configuration: SingleLocationWidgetConfigurationIntent())
    }

    func snapshot(
        for configuration: SingleLocationWidgetConfigurationIntent,
        in context: Context
    ) async -> LocationEntry {
        LocationEntry(date: Date.now, configuration: configuration)
    }
    
    func timeline(
        for configuration: SingleLocationWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<LocationEntry> {
        let date = Date.now.addingTimeInterval(900)
        let entry = LocationEntry(date: Date.now, configuration: configuration)
        return Timeline(entries: [entry], policy: .after(date))
    }
}

struct LocationEntry: TimelineEntry {
    let date: Date
    let configuration: SingleLocationWidgetConfigurationIntent
}
