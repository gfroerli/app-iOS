//
//  SingleLocationLockScreenWidgetView.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 24.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: SingleLocationWidgetTimelineProvider.Entry

    var body: some View {
        if let location = entry.configuration.location {
            switch family {
            case .accessoryInline:
                SingleLocationLockScreenWidgetInlineView(location: location)
                    .widgetURL(deepLinkURL())
                
            case .accessoryRectangular:
                SingleLocationLockScreenWidgetRectangularView(location: location)
                    .widgetURL(deepLinkURL())
                
            default:
                EmptyView()
            }
        }
        else {
            switch family {
            case .accessoryInline:
                Text("\(Image(systemName: "thermometer.medium")) ") +
                    Text("widget_no_data")
                
            case .accessoryRectangular:
                HStack {
                    Image(systemName: "thermometer.medium")
                    Text("widget_no_data")
                    Spacer()
                }
                .containerBackground(for: .widget) {
                    EmptyView()
                }
                
            default:
                EmptyView()
            }
        }
    }
    
    private struct SingleLocationLockScreenWidgetInlineView: View {
        var location: LocationAppEntity

        var body: some View {
            ViewThatFits {
                HStack {
                    Text("\(Image(systemName: "thermometer.medium")) ") +
                        Text(location.name) +
                        Text(" ") +
                        Text(location.tempString)
                }
                HStack {
                    Text("\(Image(systemName: "thermometer.medium")) ") +
                        Text(location.shortName) +
                        Text("… ") +
                        Text(location.tempString)
                }
            }
        }
    }
    
    private struct SingleLocationLockScreenWidgetRectangularView: View {
        var location: LocationAppEntity

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "thermometer.medium")
                    Text(location.tempString)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .bold()
                HStack {
                    Text(location.name)
                }
               
                if let date = location.tempDate {
                    HStack {
                        if !Calendar.current.isDateInToday(date) {
                            Text(date.formatted(date: .numeric, time: .omitted))
                        }
                        Text(date.formatted(date: .omitted, time: .shortened))
                    }
                }
            }
            .containerBackground(for: .widget) {
                EmptyView()
            }
        }
    }

    // MARK: - Private functions
    
    private func deepLinkURL() -> URL? {
        var url = URLComponents(string: "gfroerli://")!
        let queryItems = [URLQueryItem(name: "locationID", value: String(entry.configuration.location?.id ?? -1))]
        url.queryItems = queryItems
        return url.url
    }
}
