//
//  SingleLocationLockScreenWidgetView.swift
//  GfroerliWidgetExtension
//
//  Created by Marc on 24.05.2024.
//

import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: SingleLocationWidgetTimelineProvider.Entry

    var body: some View {
        switch family {
        case .accessoryInline:
            SingleLocationLockScreenWidgetInlineView(location: entry.configuration.location)
                .widgetURL(deepLinkURL())

        case .accessoryRectangular:
            SingleLocationLockScreenWidgetRectangularView(location: entry.configuration.location)
                .widgetURL(deepLinkURL())
       
        case .accessoryCircular:
            SingleLocationLockScreenWidgetCircularView(location: entry.configuration.location)
                .widgetURL(deepLinkURL())
        
        case .accessoryCorner:
            SingleLocationLockScreenWidgetCornerView(location: entry.configuration.location)
                .widgetURL(deepLinkURL())

        default:
            EmptyView()
        }
    }
    
    // MARK: - Private functions
    
    private func deepLinkURL() -> URL? {
        guard let location = entry.configuration.location else {
            return nil
        }
        var url = URLComponents(string: "gfroerli://")!
        let queryItems = [URLQueryItem(name: "locationID", value: String(location.id))]
        url.queryItems = queryItems
        return url.url
    }
}
