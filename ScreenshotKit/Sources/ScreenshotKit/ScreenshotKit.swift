// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import XCTest

/// Renders a captured `XCUIScreenshot` into a framed marketing image and wraps it as an
/// `XCTAttachment`.
///
/// The framing view is supplied by the caller, keeping this package project-agnostic: it only owns
/// device detection (`ScreenshotParameters`) and the render-to-attachment plumbing.
@MainActor
public class ScreenshotProcessor {

    public init() { }

    /// Frames `screenshot` using the caller-provided `content` view and returns it as an attachment.
    ///
    /// Returns `nil` when the current device is not a supported screenshot target, so the caller can
    /// skip it instead of crashing.
    ///
    /// - Parameters:
    ///   - screenshot: The raw captured screenshot.
    ///   - name: A short identifier for the shot (e.g. `"main"`), used to build the attachment name.
    ///   - content: Builds the framing view from the screenshot image and the resolved device metrics.
    public func process(
        _ screenshot: XCUIScreenshot,
        name: String,
        @ViewBuilder content: (UIImage, DeviceMetrics) -> some View
    ) -> XCTAttachment? {
        guard let metrics = ScreenshotParameters.current else { return nil }

        let renderer = ImageRenderer(content: content(screenshot.image, metrics))
        guard let image = renderer.uiImage else { return nil }

        let attachment = XCTAttachment(image: image)
        attachment.lifetime = .keepAlways
        attachment.name = metrics.identifier + "_" + name
        return attachment
    }
}
