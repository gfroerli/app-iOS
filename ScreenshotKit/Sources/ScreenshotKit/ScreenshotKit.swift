// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import XCTest

@MainActor
public class ScreenshotProcessor {
    
    public init() { }

    public func process(_ screenshot: XCUIScreenshot, type: ScreenshotType) -> XCTAttachment {
        
        let attachment = XCTAttachment(image: embeddInSwiftui(screenshot, type: type)!)
        attachment.lifetime = .keepAlways
        attachment.name = ScreenshotParameters.name + type.nameAppendix
        return attachment
    }
    
    private func embeddInSwiftui(_ screenshot: XCUIScreenshot, type: ScreenshotType) -> UIImage? {
        let renderer = ImageRenderer(content: ScreenshotView(contentImage: screenshot.image, type: type))

        if let uiImage = renderer.uiImage {
            return uiImage
        }
        fatalError()
        return nil
    }
    
    public enum ScreenshotType {
        case main, search, location
        
        public var nameAppendix: String {
            switch self {
            case .main:
                "main"
            case .search:
                "search"
            case .location:
                "location"
            }
        }
        
        public var title: String {
            switch self {
            case .main:
                String(localized: "title_main", bundle: .module)
            case .search:
                String(localized: "title_search", bundle: .module)
            case .location:
                String(localized: "title_location", bundle: .module)
            }
        }
        
        public var text: String {
            switch self {
            case .main:
                String(localized: "text_main", bundle: .module)
            case .search:
                String(localized: "text_search", bundle: .module)
            case .location:
                String(localized: "text_location", bundle: .module)
            }
        }
    }
}
