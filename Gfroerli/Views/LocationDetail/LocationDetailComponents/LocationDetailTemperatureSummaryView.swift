//
//  LocationDetailTemperatureSummaryView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliBusinessProtocols
import SwiftUI

struct LocationDetailTemperatureSummaryView: View {

    var location: BusinessLocationProtocol

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("temperature_summary_view_title")
                    .font(.title3)
                    .bold()
            }

            VStack {
                HStack {
                    Text("temperature_summary_view_highest")
                    Spacer()
                    Text(location.highestTemperatureString)
                        .font(.body.weight(.semibold))
                }

                HStack {
                    Text("temperature_summary_view_average")
                    Spacer()
                    Text(location.averageTemperatureString)
                        .font(.body.weight(.semibold))
                }

                HStack {
                    Text("temperature_summary_view_lowest")
                    Spacer()
                    Text(location.lowestTemperatureString)
                        .font(.body.weight(.semibold))
                }
            }
        }
        .minimumScaleFactor(0.1)
        .frame(maxHeight: .infinity)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}
