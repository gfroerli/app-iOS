//
//  SingleLocationLockScreenWidgetCircularView.swift
//  Gfroerli
//
//  Created by Marc on 06.01.2026.
//

import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetCircularView: View {
    var location: LocationAppEntity?

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                if let location {
                    if location.isActive {
                        Text(location.tempString)
                            .bold()
                            .minimumScaleFactor(0.5)
                    }
                    else {
                        Text(verbatim: "-")
                    }
                        
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: "thermometer.medium")
                            .imageScale(.small)
                        Text(location.shortName)
                    }
                    .font(.caption)
                }
                else {
                    VStack {
                        Image(systemName: "thermometer.medium.slash")
                        Text("widget_no_data_short")
                            .font(.caption)
                    }
                }
            }
            .padding(4)
        }
        .containerBackground(for: .widget) {
            EmptyView()
        }
    }
}
