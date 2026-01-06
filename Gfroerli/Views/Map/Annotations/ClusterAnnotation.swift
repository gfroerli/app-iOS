//
//  ClusterAnnotation.swift
//  Gfroerli
//
//  Created by Marc on 30.12.2025.
//

import Foundation
import MapKit
import SwiftUI

struct ClusterAnnotation: View {
    @Environment(\.colorScheme) var colorScheme

    var locations: [MapLocation]
    
    private var tintColor: Color {
        colorScheme == .light ? Color.accentColor : .white
    }
    
    // MARK: - Body

    var body: some View {
        Text(verbatim: "+\(locations.count)")
            .foregroundStyle(tintColor)
            .bold()
            .font(.title3)
            .padding(6)
            .glassEffect(.regular)
    }
}
