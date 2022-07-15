//
//  PreViewExtension.swift
//  iOS
//
//  Created by Marc Kramer on 20.10.20.
//

import Foundation
import SwiftUI

struct PreviewProviderModifier: ViewModifier {
    func body(content: Content)->some View {
        Group {

            content
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")

            content
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
               .previewDisplayName("iPhone 11 Pro")

            content
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")

            content
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")

            content
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")

            content
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")

        }
    }

}

extension View {

    func makePreViewModifier() -> some View {
        modifier(PreviewProviderModifier())
    }
}
