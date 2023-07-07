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
            .frame(maxWidth: .infinity)
            .cornerRadius(15)
            .shadow(color: .secondary.opacity(0.5), radius: 3)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.primary, lineWidth: 0.1)
            }
            .padding(.horizontal)
    }
}
