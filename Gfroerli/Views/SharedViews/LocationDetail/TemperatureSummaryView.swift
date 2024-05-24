//
//  TemperatureSummaryView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliBackend
import SwiftUI

struct TemperatureSummaryView: View {
    typealias config = AppConfiguration.LocationDetails

    var location: Location?

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("temperature_summary_view_title")
                    .font(.title2.bold())
            }

            VStack {
                HStack {
                    Text("temperature_summary_view_highest")
                    Spacer()
                    Text(location!.highestTemperatureString)
                }

                HStack {
                    Text("temperature_summary_view_average")
                    Spacer()
                    Text(location!.averageTemperatureString)
                }

                HStack {
                    Text("temperature_summary_view_lowest")
                    Spacer()
                    Text(location!.lowestTemperatureString)
                }
            }
        }
        .font(.body)
        .minimumScaleFactor(0.1)
        .frame(maxHeight: .infinity)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

// MARK: - Preview

struct TemperatureSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureSummaryView(location: Location.exampleLocation())
    }
}
