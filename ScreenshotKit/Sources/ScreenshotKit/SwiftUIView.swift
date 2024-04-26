//
//  SwiftUIView.swift
//
//
//  Created by Marc on 25.12.2023.
//

import SwiftUI

struct ScreenshotView: View {
    
    let contentImage: UIImage
    let type: ScreenshotProcessor.ScreenshotType
    var body: some View {
        ZStack {
            VStack {
                Text(type.title)
                    .font(.system(size: 100))
                    .bold()
                    .padding(.top, 80)
                Text(type.text)
                    .font(.system(size: 60))
                Spacer()
            }
            .multilineTextAlignment(.center)
            .fontDesign(.rounded)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            ZStack {
                Image(uiImage: contentImage)
                    .resizable()
                    .frame(width: ScreenshotParameters.imageWidth, height: ScreenshotParameters.imageHeight)
                    .cornerRadius(ScreenshotParameters.imageCornerRadius)
                ScreenshotParameters.deviceFrame
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.offset(x: 0, y: 300 + ScreenshotParameters.additionalDeviceOffset)
        }
        .frame(width: ScreenshotParameters.frameWidth, height: ScreenshotParameters.frameHeight)
        .background {
            ZStack {
                Color("MainColor", bundle: .module)
                Wave(strength: 20, frequency: 10, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.5))
                Wave(strength: 10, frequency: 10, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.8))
                    .offset(y: 100)
            }
        }
    }
}

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
