//
//  LatestTemperatureView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliBusinessMocks
import GfroerliBusinessProtocols
import SwiftUI

struct LocationDetailLastTemperatureView: View {

    var location: BusinessLocationProtocol

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("latest_temperature_view_title")
                    .font(.title3)
                    .bold()
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()

                VStack(alignment: .trailing) {
                    Text(location.lastTemperatureString)
                        .bold()
                        .font(.title)
                    Text(location.lastTemperatureDateString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                      //  .minimumScaleFactor(0.5)
                        .lineLimit(2)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

#Preview {
    LocationDetailLastTemperatureView(location: BusinessLocationMock.exampleLocation1)
}
