//
//  WatchListContenView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 27.05.2024.
//

import GfroerliBackend
import SwiftUI
struct WatchListContentView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name ?? "")
                .font(.subheadline)
            HStack {
                Spacer()
                VStack {
                    Text(location.latestTemperatureString)
                        .font(.title)
                        .bold()
                    Text(location.lastTemperatureDateString)
                        .font(.caption2)
                }
            }
        }
        .foregroundStyle(location.isActive ? .white : .white.opacity(0.7))
    }
}

#Preview {
    WatchMainView()
        .environment(AllLocationsViewModel())
}
