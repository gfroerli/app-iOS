//
//  SingleLocationLockScreenWidgetInlineView.swift
//  Gfroerli
//
//  Created by Marc on 06.01.2026.
//

import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetInlineView: View {
    var location: LocationAppEntity?
        
    var tempString: String {
        guard let location, location.isActive else {
            return String(localized: "widget_inactive")
        }
        return location.tempString
    }
        
    var body: some View {
        if let location {
            #if os(watchOS)
                ViewThatFits {
                    Text(location.name + " " + tempString)
                    Text(location.shortName + " " + tempString)
                }
            #elseif os(iOS)
                VStack {
                    Image(systemName: "thermometer.medium")
                    ViewThatFits {
                        Text(location.name + " " + tempString)
                        Text(location.shortName + " " + tempString)
                    }
                }
            #endif
        }
        else {
            HStack {
                Image(systemName: "thermometer.medium.slash")
                Text("widget_no_data_short")
            }
        }
    }
}
