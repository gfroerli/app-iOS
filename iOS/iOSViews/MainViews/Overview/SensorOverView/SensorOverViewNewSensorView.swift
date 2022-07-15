//
//  SensorOverViewNewSensorView.swift
//  iOS
//
//  Created by Marc Kramer on 12.02.22.
//

import SwiftUI

struct SensorOverViewNewSensorView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("New Location:").font(.title3).bold()
                Text("This Location was recently added and measurements will be available very soon.", comment: "Test comment")}
            Spacer()
        }
        .padding()
    }
}

struct SensorOverViewNewSensorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverViewNewSensorView()
    }
}
