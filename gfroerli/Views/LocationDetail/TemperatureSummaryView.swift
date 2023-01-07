//
//  TemperatureSummaryView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import GfroerliAPI
import SwiftUI

struct TemperatureSummaryView: View {

    typealias config = AppConfiguration.LocationDetails
    
    @Binding var location: Location?

    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("All time:")
                    .font(.title2.bold())
            }
            
            VStack {
                HStack {
                    Text("Highest:")
                    Spacer()
                    Text(location!.highestTemperatureString)
                }
                
                HStack {
                    Text("Average:")
                    Spacer()
                    Text(location!.averageTemperatureString)
                }
                
                HStack {
                    Text("Lowest:")
                    Spacer()
                    Text(location!.lowestTemperatureString)
                }
            }
        }
        .font(.body)
        .minimumScaleFactor(0.1)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

struct TemperatureSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureSummaryView(location: Binding.constant(Location.exampleLocation()))
    }
}
