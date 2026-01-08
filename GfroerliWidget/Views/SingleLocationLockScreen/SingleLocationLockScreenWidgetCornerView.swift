//
//  SingleLocationLockScreenWidgetCornerView.swift
//  Gfroerli
//
//  Created by Marc on 06.01.2026.
//

import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetCornerView: View {
    var location: LocationAppEntity?

    var body: some View {
        ZStack {
            if let location {
                HStack {
                    if location.isActive {
                        Text(location.tempString)
                            .bold()
                    }
                    else {
                        Text("widget_inactive")
                    }
                }
                .widgetCurvesContent()
                .widgetLabel {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: "thermometer.medium")
                            .imageScale(.small)
                        Text(location.name)
                    }
                    .font(.caption)
                }
            }
            else {
                HStack {
                    Text("widget_no_data_short")
                        .font(.caption)
                }
                .widgetCurvesContent()
                .widgetLabel {
                    Image(systemName: "thermometer.medium.slash")
                }
            }
        }
        .containerBackground(for: .widget) {
            EmptyView()
        }
    }
}
