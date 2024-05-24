//
//  LatestTemperatureView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliBackend
import SwiftUI

struct LatestTemperatureView: View {
    typealias config = AppConfiguration.LocationDetails

    var location: Location?

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top) {
            Text("latest_temperature_view_title")
                .minimumScaleFactor(0.1)
                .bold()
                
            Spacer()
            VStack(alignment: .trailing) {
                Spacer()
                Text(location!.latestTemperatureString)
                    .bold()
                    .font(.title)
                Text(location!.lastTemperatureDateString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.1)
                    .lineLimit(2)
            }
        }
        .font(.title2)
        .frame(maxHeight: .infinity)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

// MARK: - Preview

struct LatestTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        LatestTemperatureView(location: Location.exampleLocation())
    }
}
