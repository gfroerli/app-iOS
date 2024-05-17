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
    var entry: SingleLocationWidgetTimelineProvider.Entry

    var body: some View {
        VStack {
            HStack {
                Text(entry.configuration.location?.name ?? "")
                    .font(.callout)
                    .lineLimit(2, reservesSpace: true)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text(entry.configuration.location?.tempString ?? "")
                    .font(.title)
                    .bold()
            }
            
            Spacer()
            
            if let date = entry.configuration.location?.tempDate {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(date.formatted(date: .omitted, time: .shortened))
                        if !Calendar.current.isDateInToday(date) {
                            Text(date.formatted(date: .numeric, time: .omitted))
                        }
                        Text("Debug ") + Text(entry.date, style: .time)
                    }
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                }
            }
        }
        .fontWeight(.semibold)
        .padding(0)
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
    }
}
