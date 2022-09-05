//
//  LatestTemperatureView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import SwiftUI
import GfroerliAPI

struct LatestTemperatureView: View {
    
    typealias config = AppConfiguration.LocationDetails
    
    @Binding var location: Location?
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            Text("Latest:")
                .minimumScaleFactor(0.1)
            
            Spacer()
            VStack(alignment: .trailing) {
                Text(location!.latestTemperatureString)
                Text(location!.lastTemperatureDateString)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.1)
                    .lineLimit(2)
            }
        }
        .font(.largeTitle)
        .bold()
        .padding()
        .defaultBoxStyle()
    }
}

// MARK: - Preview
struct LatestTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        LatestTemperatureView(location: Binding.constant(Location.exampleLocation()))
    }
}
