//
//  WatchTemperatureSummaryView'.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 30.05.2024.
//

import GfroerliBackend
import SwiftUI
struct WatchTemperatureSummaryView: View {
    let location: Location
    var body: some View {
        VStack(spacing: 0) {
            Text(location.name ?? "")
                .font(.headline)
               
            Text(location.latestTemperatureString)
                .font(.system(size: 45))
                .bold()
                .padding()
            Text(location.lastTemperatureDateString)
                .font(.subheadline)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    WatchLocationDetailTabView(locationID: 1)
}
