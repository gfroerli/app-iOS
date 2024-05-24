//
//  View+Modifiers.swift
//  gfroerli
//
//  Created by Marc Kramer on 25.06.22.
//

import Foundation
import SwiftUI

extension View {
    func defaultBoxStyle() -> some View {
        background(backgroundColor())
            .cornerRadius(15)
            .shadow(color: .clear, radius: 0)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.accentColor.opacity(0.4), lineWidth: 0.5)
            }
    }
    
    private func backgroundColor() -> Color {
        @Environment(\.colorScheme) var colorScheme

        if colorScheme == .light {
            return Color.accentColor.opacity(0.05)
        }
        else {
            return Color.accentColor.opacity(0.5)
        }
    }
}
