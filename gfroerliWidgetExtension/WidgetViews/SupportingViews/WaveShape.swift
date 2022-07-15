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
    // how high our waves should be
    var strength: Double

    // how frequent our waves should be
    var frequency: Double

    var offset: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // calculate some important values up front
        let width = Double(rect.width*2)
        let height = Double(rect.height)
        let midHeight = height / 2

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0-offset, y: 10000))
        path.addLine(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX)

            let y = strength * sine + midHeight

                    // add a line to here
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine(to: CGPoint(x: 500, y: midHeight))
                return Path(path.cgPath)
            }
}
