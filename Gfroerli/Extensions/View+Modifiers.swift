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
        background(Color.accentColor.opacity(0.05))
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.accentColor.opacity(0.4), lineWidth: 0.5)
            }
    }
}
