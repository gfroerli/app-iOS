//
//  GfroerliWidget.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

struct SingleLocationWidgetView: View {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    var entry: SingleLocationWidgetTimelineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.configuration.location?.name ?? "widget_no_data")
                    .font(showsBackground ? .callout : .title3)
                    .lineLimit(2, reservesSpace: true)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text(entry.configuration.location?.tempString ?? "")
                    .font(showsBackground ? .title : .largeTitle)
                    .bold()
            }
            
            Spacer()
            
            HStack(alignment: .bottom) {
                Image(systemName: "thermometer.medium")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .white, .accent)
                    .font(showsBackground ? .subheadline : .headline)
                
                Spacer()
                
                ZStack {
                    Text(entry.configuration.location?.tempDateString ?? "")
                        .lineLimit(2)
                    Text("")
                        .lineLimit(2, reservesSpace: true)
                }
                .multilineTextAlignment(.trailing)
            }
            .font(showsBackground ? .caption2 : .caption)
        }
        .fontWeight(.semibold)
        .padding(showsBackground ? 0 : 5)
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            ZStack {
                Color(.accent)
                Wave(strength: 3, frequency: 7, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.5))
                    .scaleEffect(x: -1, y: 1)
                    .offset(y: 2)
                Wave(strength: 5, frequency: 6, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.8))
                    .offset(y: 6)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
        .widgetURL(deepLinkURL())
    }
    
    private func deepLinkURL() -> URL? {
        var url = URLComponents(string: "gfroerli://")!
        let queryItems = [URLQueryItem(name: "locationID", value: String(entry.configuration.location?.id ?? -1))]
        url.queryItems = queryItems
        return url.url
    }
}
