//
//  WatchListContentView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 27.05.2024.
//

import GfroerliBusinessProtocols
import SwiftUI

struct WatchListContentView: View {
    let location: BusinessLocationProtocol
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.subheadline)
            HStack {
                Spacer()
                VStack {
                    Text(location.lastTemperatureString)
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
