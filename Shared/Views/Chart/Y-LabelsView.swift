//
//  Y-LabelsView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct YLabelsView: View {

    var nrOfLines: Int

    @Binding var max: Double
    @Binding var min: Double

    var yLabels: [String] {
        let stepSize = (max-min)/(Double(nrOfLines-1))
        var yLabels = [String]()

        for line in 0..<nrOfLines {
            yLabels.append(makeTemperatureString(double: min + Double(line) * stepSize))
        }

        return yLabels.reversed()
    }

    var body: some View {
        VStack(alignment: .trailing) {
            ForEach(yLabels.indices) {index in
                if index != 0 { Spacer() }
                Text(yLabels[index])
            }
        }
    }
}

struct YLabelsView_Previews: PreviewProvider {
    static var previews: some View {
        YLabelsView(nrOfLines: 5, max: .constant(30.0), min: .constant(0.0))
    }
}
