//
//  WatchTemperatureHistoryView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 30.05.2024.
//

import GfroerliBackend
import SwiftUI

struct WatchTemperatureHistoryView: View {
    let location: Location

    var body: some View {
        VStack {
            TabView {
                Text("temperature_history_view_picker_day")
                    .tag(0)
                Text("temperature_history_view_picker_week")
                    .tag(1)
                Text("temperature_history_view_picker_month")
                    .tag(2)
            }
            .tabViewStyle(.page)
            .frame(maxHeight: .infinity)
        }
        .padding()
        .navigationTitle("temperature_history_view_title")
    }
}

#Preview {
    WatchLocationDetailTabView(locationID: Location.exampleLocation().id)
}
