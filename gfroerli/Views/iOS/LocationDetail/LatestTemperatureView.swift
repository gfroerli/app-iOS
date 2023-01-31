//
//  LatestTemperatureView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliAPI
import SwiftUI

struct LatestTemperatureView: View {
    
    typealias config = AppConfiguration.LocationDetails
    
    @Binding var location: Location?
    
    // MARK: - Body

    var body: some View {
        HStack(alignment: .top) {
            Text("Latest:")
                .minimumScaleFactor(0.1)
                .bold()
            
            Spacer()
            VStack(alignment: .trailing) {
                Text(location!.latestTemperatureString)
                    .bold()

                Text(location!.lastTemperatureDateString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.1)
                    .lineLimit(2)
            }
        }
        .font(.title2)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

// MARK: - Preview

struct LatestTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        LatestTemperatureView(location: Binding.constant(Location.exampleLocation()))
    }
}
