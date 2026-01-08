//
//  SingleLocationLockScreenWidgetRectangularView.swift
//  Gfroerli
//
//  Created by Marc on 06.01.2026.
//

import SwiftUI
import WidgetKit

struct SingleLocationLockScreenWidgetRectangularView: View {
    var location: LocationAppEntity?

    var body: some View {
        ZStack {
            if let location {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "thermometer.medium")
                            .imageScale(.small)
                        Text(location.tempString)
                        Spacer()
                    }
                    .bold()
                        
                    HStack {
                        Text(location.name)
                    }
                        
                    Text(location.tempDateString)
                        .multilineTextAlignment(.trailing)
                }
            }
            else {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "thermometer.medium.slash")
                    Text("widget_no_data_short")
                    Spacer()
                }
            }
        }
        .containerBackground(for: .widget) {
            EmptyView()
        }
    }
}
