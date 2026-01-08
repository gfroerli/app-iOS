//
//  WatchTemperatureSummaryView'.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 30.05.2024.
//

import GfroerliBusinessProtocols
import SwiftUI

@MainActor
struct WatchTemperatureSummaryView: View {
    
    let location: BusinessLocationProtocol
    
    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Text(location.name)
                .font(.headline)
               
            Text(location.lastTemperatureString)
                .font(.system(size: 45))
                .bold()
                .padding(2)
            Text(location.lastTemperatureDateString)
                .font(.subheadline)
        }
        .frame(maxHeight: .infinity)
    }
}
