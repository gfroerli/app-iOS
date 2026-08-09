//
//  ScreenshotParameters.swift
//
//
//  Created by Marc on 25.12.2023.
//

import DeviceKit
import Foundation
import SwiftUI

/// Layout metrics for the marketing screenshot of a single device size class.
///
/// `frameSize` is the exact App Store Connect canvas (and therefore the exact pixel size of the
/// rendered attachment); `imageSize` is the size of the embedded app screenshot inside that canvas.
public struct DeviceMetrics {

    /// Filename prefix identifying the size class, e.g. `"iPhone_6.9"` or `"iPad_13"`.
    public let identifier: String

    /// Exact App Store canvas / output pixel size.
    public let frameSize: CGSize

    /// Size of the embedded app screenshot within the canvas.
    public let imageSize: CGSize

    /// Corner radius applied to the embedded screenshot.
    public let imageCornerRadius: CGFloat

    /// Extra vertical offset applied to the embedded device, for fine tuning per size class.
    public let deviceOffset: CGFloat

    /// Device bezel artwork for this size class.
    public let deviceFrame: Image

    public init(
        identifier: String,
        frameSize: CGSize,
        imageSize: CGSize,
        imageCornerRadius: CGFloat,
        deviceOffset: CGFloat,
        deviceFrame: Image
    ) {
        self.identifier = identifier
        self.frameSize = frameSize
        self.imageSize = imageSize
        self.imageCornerRadius = imageCornerRadius
        self.deviceOffset = deviceOffset
        self.deviceFrame = deviceFrame
    }
}

public enum ScreenshotParameters {

    /// Metrics for the current simulator, or `nil` when the device is not a supported screenshot
    /// target (the caller should skip it rather than crash).
    public static var current: DeviceMetrics? {
        guard case let .simulator(model) = Device.current else { return nil }

        switch model {

        // 6.9" iPhone — 1320 x 2868 portrait (iPhone 17 Pro Max)
        case .iPhone17ProMax:
            // The bezel PNG is 1470x3000 for a 1320x2868 screen. Fitting it to the 1320-wide
            // canvas scales the glass by 1320/1470, so the screenshot must match to fill it.
            return DeviceMetrics(
                identifier: "iPhone_6.9",
                frameSize: CGSize(width: 1320, height: 2868),
                imageSize: CGSize(width: 1320 * (1320.0 / 1470.0), height: 2868 * (1320.0 / 1470.0)),
                imageCornerRadius: 150,
                deviceOffset: 0,
                deviceFrame: Image("iPhone17ProMax", bundle: .module)
            )

        // 13" iPad — 2752 x 2064 landscape (iPad Pro 13" M5)
        case .iPadPro13M5:
            // The bezel PNG is 3000x2300 for a 2752x2064 screen. In landscape the fit is
            // height-limited, so the glass scales by 2064/2300.
            return DeviceMetrics(
                identifier: "iPad_13",
                frameSize: CGSize(width: 2752, height: 2064),
                imageSize: CGSize(width: 2752 * (2064.0 / 2300.0), height: 2064 * (2064.0 / 2300.0)),
                imageCornerRadius: 40,
                deviceOffset: 0,
                deviceFrame: Image("iPadProM5", bundle: .module)
            )

        // Extend here for Apple Watch, e.g.:
        // case .appleWatchUltra2: return DeviceMetrics(...)

        default:
            return nil
        }
    }
}
