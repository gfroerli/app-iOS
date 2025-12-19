//
//  LocationAnnotation.swift
//  gfroerli
//
//  Created by Marc on 02.09.22.
//

import MapKit
import SwiftUI

struct LocationAnnotation: View {
    @Environment(\.colorScheme) var colorScheme

    var location: MapLocation
    @Binding var expanded: Bool
    
    private var tintColor: Color {
        if location.isActive {
            colorScheme == .light ? Color.accentColor : .white
        }
        else {
            Color.gray
        }
    }
    
    // MARK: - Body

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "thermometer.medium")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, tintColor, tintColor)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                if expanded {
                    Text(location.name)
                }
                if location.isActive {
                    Text(location.lastTemperatureString)
                }
            }
            .foregroundStyle(tintColor)
            .bold()
            .font(.title3)
            .fixedSize(horizontal: true, vertical: true)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .glassEffect(.regular)
    }
}
