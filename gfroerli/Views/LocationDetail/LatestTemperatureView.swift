//
//  LatestTemperatureView.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import SwiftUI
import GfroerliAPI

struct LatestTemperatureView: View {

    typealias config = AppConfiguration.LoacationDetails

    @Environment(\.colorScheme) var colorScheme
    @Binding var location: Location
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Latest Temperature: ")
                    .minimumScaleFactor(0.1)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2, reservesSpace: true)
                Spacer()
            }

            HStack {
                Spacer()
                VStack(alignment:.trailing) {
                    Text(location.latestTemperatureString)
                    Text(location.lastTemperatureDateString)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.1)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                }
            }

        }
        .font(.largeTitle.bold())
        .padding()
    }
}

// MARK: - Preview
struct LatestTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        LatestTemperatureView(location: Binding.constant(Location.exampleLocation()))
    }
}
