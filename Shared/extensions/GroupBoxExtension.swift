//
//  GroupBoxExtension.swift
//  iOS
//
//  Created by Marc Kramer on 02.01.21.
//

import Foundation
import SwiftUI

struct ColoredGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
            .fill(Color.secondarySystemGroupedBackground))
    }
}
