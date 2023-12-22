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
        @Environment(\.colorScheme) var colorScheme

        return background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(color: .clear, radius: 0)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.primary, lineWidth: 0.1)
            }
    }
}
