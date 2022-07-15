//
//  ChartShape.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//
// swiftlint:disable identifier_name


import Foundation
import SwiftUI

struct LineShape: Shape {

    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    @Binding var totalSteps: Int

    var vector: AnimatableVector
    var steps: [Int]

    var animatableData: AnimatableVector {
            get { vector }
            set { vector = newValue }
        }

    @Binding var minValue: Double
    @Binding var maxValue: Double
    @Binding var timeFrame: TimeFrame

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let xMultiplier = rect.width / CGFloat(totalSteps)
        let yMultiplier = rect.height / CGFloat(maxValue-minValue)

        // Line to first DataPoint
       if steps[0] != 1 {
            var x = xMultiplier * CGFloat(0)
            var y = yMultiplier * CGFloat(vector.values[0]-minValue)
            y = rect.height - y
            x += rect.minX
            y += rect.minY

            path.move(to: CGPoint(x: x, y: y))
        }

        // First DataPoint
        var x = xMultiplier * CGFloat(steps[0])
        var y = yMultiplier * CGFloat(vector.values[0]-minValue)

        y = rect.height - y
        x += rect.minX
        y += rect.minY

        // Connect Line to first datapoint if not at begging of period
        if steps[0] != 1 {
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: y))

        for index in 1..<vector.values.count {
            var x = xMultiplier * CGFloat(steps[index])
            var y = yMultiplier * CGFloat(vector.values[index]-minValue)

            y = rect.height - y
            x += rect.minX
            y += rect.minY

            path.addLine(to: CGPoint(x: x, y: y))
        }

        if steps[vector.values.count-1] != totalSteps && !checkTimeFrame() {

            var x = xMultiplier * CGFloat(totalSteps)
            var y = yMultiplier * CGFloat(vector.values[vector.values.count-1]-minValue)

            y = rect.height - y
            x += rect.minX
            y += rect.minY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return path
    }

    private func checkTimeFrame() -> Bool {
        switch timeFrame {
        case .day:
            return temperatureAggregationsVM.isInSameDay
        case .week:
            return temperatureAggregationsVM.isInSameWeek
        default:
            return temperatureAggregationsVM.isInSameMonth
        }
    }
}
