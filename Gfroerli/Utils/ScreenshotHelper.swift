//
//  ScreenshotHelper.swift
//  Gfroerli
//
//  Created by Marc on 05.04.2024.
//

import SwiftUI

import ScreenshotKit

struct ScreenshotHelper: View {
    
    let contentImage: UIImage
    let type: ScreenshotProcessor.ScreenshotType
    var body: some View {
        ZStack {
            VStack {
                Text(type.title)
                    .font(.system(size: 120))
                    .bold()
                    .padding(.top, 80)
                Text(type.text)
                    .font(.system(size: 75))
                Spacer()
            }
            .fontDesign(.rounded)
            .foregroundColor(.white)
            
            ZStack {
                Image(uiImage: contentImage)
                    .resizable()
                    .frame(width: ScreenshotParameters.imageWidth, height: ScreenshotParameters.imageHeight)
                    .cornerRadius(ScreenshotParameters.imageCornerRadius)
                ScreenshotParameters.deviceFrame
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.offset(x: 0, y: 300)
                .opacity(0.2)
        }
        .frame(width: ScreenshotParameters.frameWidth, height: ScreenshotParameters.frameHeight)
        .background {
            ZStack {
                Color(uiColor: UIColor.tintColor)
                Wave(strength: 20, frequency: 10, offset: 0)
                    .foregroundStyle(.cyan)
                Wave(strength: 10, frequency: 10, offset: 0)
                    .foregroundStyle(Color.accentColor)
                    .offset(y: 100)
                    .preferredColorScheme(.light)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ScreenshotHelper(contentImage: UIImage(systemName: "pin")!, type: .main)
        .background(.red)
}

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
