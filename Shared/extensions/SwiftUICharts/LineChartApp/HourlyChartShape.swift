//
//  HourlyChartShape.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
//
// swiftlint:disable identifier_name

import Foundation
import SwiftUI

struct HourlyLineChartShape: Shape {
    var data: [HourlyAggregation?]
    var pointSize: CGFloat
    var maxVal: Double
    var minVal: Double
    var tempType: TempType
    var showCircles: Bool

    init(pointSize: CGFloat, data: [HourlyAggregation?], type: TempType, max: Double, min: Double, showCircles: Bool) {
        self.tempType = type
        self.data = data
        self.pointSize = pointSize
        self.maxVal = max.rounded(.up)
        self.minVal = min.rounded(.down)
        self.showCircles = showCircles
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let xMultiplier = rect.width / CGFloat(23)
        let yMultiplier = rect.height / CGFloat(maxVal-minVal)

        // Move to first pos
        var x = xMultiplier * CGFloat(0)
        var y = yMultiplier * CGFloat(getTemp(dataPoint: data.first(where: { $0 != nil})!!)-minVal)
        y = rect.height - y
        x += rect.minX
        y += rect.minY

        path.move(to: CGPoint(x: x, y: y))
        x = xMultiplier * CGFloat(0)

        // start path
        for i in 0..<data.count {
            if data[i] == nil {
                continue
            }

            var x = xMultiplier * CGFloat(i)
            var y = yMultiplier * CGFloat(getTemp(dataPoint: data[i]!)-minVal)

            y = rect.height - y
            x += rect.minX
            y += rect.minY
            path.addLine(to: CGPoint(x: x, y: y))

            if showCircles {
                x -= pointSize / 2
                y -= pointSize / 2
                path.addEllipse(in: CGRect(x: x, y: y, width: pointSize, height: pointSize))
                path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
            }

        }

        // end last path part if last entry is nil

        return path
    }

    private func getTemp(dataPoint: HourlyAggregation) -> Double {
        switch tempType {
        case .average:
            return dataPoint.avgTemp!
        case.maximum:
            return dataPoint.maxTemp!
        case.minimum:
            return dataPoint.minTemp!

        }
    }
}
