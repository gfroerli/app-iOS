//
//  ScreenshotFrameView.swift
//  GfroerliUITests
//
//  The Gfrör.li marketing frame composed around a captured screenshot. This is the project-specific
//  presentation (waves, brand color, captions); ScreenshotKit only supplies the device metrics/bezel.
//

import ScreenshotKit
import SwiftUI
import UIKit

struct ScreenshotFrameView: View {

    let contentImage: UIImage
    let title: String
    let subtitle: String?
    let metrics: DeviceMetrics

    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.system(size: 120))
                    .bold()
                    .padding(.top, 80)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 75))
                }
                Spacer()
            }
            .multilineTextAlignment(.center)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding(.horizontal)

            ZStack {
                Image(uiImage: contentImage)
                    .resizable()
                    .frame(width: metrics.imageSize.width, height: metrics.imageSize.height)
                    .cornerRadius(metrics.imageCornerRadius)
                metrics.deviceFrame
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .offset(x: 0, y: 300 + metrics.deviceOffset)
        }
        .frame(width: metrics.frameSize.width, height: metrics.frameSize.height)
        .background {
            ZStack {
                Self.brandColor
                Wave(strength: 20, frequency: 10, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.5))
                Wave(strength: 10, frequency: 10, offset: 0)
                    .foregroundStyle(.cyan.opacity(0.8))
                    .offset(y: 100)
            }
        }
    }

    /// Gfrör.li brand background (formerly the package's `MainColor`).
    static let brandColor = Color(.displayP3, red: 0.250, green: 0.298, blue: 0.666)
}

/// Sine background wave used behind the framed device.
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
            let y = strength * sin(relativeX) + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0 - offset, y: height))
        return Path(path.cgPath)
    }
}

#Preview("iPhone 6.9\"", traits: .sizeThatFitsLayout) {
    ScreenshotFrameView(
        contentImage: .previewPlaceholder(size: CGSize(width: 1320, height: 2868), color: .systemTeal),
        title: "Gfrör.li",
        subtitle: "Realtime watertemperatures at various locations.",
        metrics: DeviceMetrics(
            identifier: "iPhone_6.9",
            frameSize: CGSize(width: 1320, height: 2868),
            imageSize: CGSize(width: 1320 / 1.2, height: 2868 / 1.2),
            imageCornerRadius: 75,
            deviceOffset: 0,
            deviceFrame: Image(systemName: "iphone")
        )
    )
}

private extension UIImage {
    /// A solid-color placeholder image for previews (stands in for a captured screenshot).
    static func previewPlaceholder(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
