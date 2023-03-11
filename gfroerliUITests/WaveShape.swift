//
//  WaveShape.swift
//  iOS
//
//  Created by Marc on 27.03.21.
//
// swiftlint:disable identifier_name

import Foundation
import SwiftUI

struct Wave: Shape {
    var strength: Double
    var frequency: Double

    var offset: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = Double(rect.width)
        let height = Double(rect.height)
        let midHeight = height / 6 * 4

        let wavelength = width / frequency

        path.move(to: CGPoint(x: 0 - offset, y: 0))
        path.addLine(to: CGPoint(x: 0 - offset, y: 0))

        for x in stride(from: 0 - offset, through: width, by: 1) {
            let relativeX = x / wavelength

            let sine = sin(relativeX)

            let y = strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))

        path.addLine(to: CGPoint(x: 0 - offset, y: height))
        return Path(path.cgPath)
    }
}
