//
//  TemperatureSummaryView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import SwiftUI
import GfroerliAPI

struct TemperatureSummaryView: View {

    typealias config = AppConfiguration.LoacationDetails
    
    @Binding var location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text("All time:")
                    .font(.title.bold())
            }
            .padding(.bottom)
            
            HStack {
                Text("Highest:")
                Spacer()
                Text(location.highestTemperatureString)
            }
            
            HStack {
                Text("Average:")
                Spacer()
                Text(location.averageTemperatureString)
            }
            
            HStack {
                Text("Lowest:")
                Spacer()
                Text(location.lowestTemperatureString)
            }
        }
        .font(.title2)
        .minimumScaleFactor(0.1)
        .padding()
    }
}

struct TemperatureSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureSummaryView(location: Binding.constant(Location.example()))
    }
}
