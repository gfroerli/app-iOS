//
//  MapAnnotation.swift
//  gfroerli
//
//  Created by Marc on 02.09.22.
//

import GfroerliBackend
import MapKit
import SwiftUI

struct GfroerliMapAnnotation: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var zoomed: Bool
    
    let location: Location

    private var color: Color {
        location.isActive ? Color.accentColor : Color.gray
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "thermometer.medium")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .white, colorScheme == .light ? Color.accentColor : .white.opacity(0.3))
                
                Text(location.name ?? "sdafasdf")
                if location.isActive {
                    Text(location.latestTemperatureString)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .fixedSize()
            .fontWeight(AppConfiguration.MapView.fontWeight)
            .foregroundColor(.white)
            .padding(8)
            .background(color.opacity(colorScheme == .light ? 0.5 : 0.8))
            .border(color, width: 2)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(colorScheme == .light ? Color.accentColor : .white.opacity(0.3), lineWidth: 2)
            }
            .opacity(zoomed ? 1 : 0)
            
            Circle()
                .strokeBorder(colorScheme == .light ? Color.accentColor : .white.opacity(0.3), lineWidth: 2)
                .background(Circle().fill(color.opacity(colorScheme == .light ? 0.5 : 0.8)))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white, colorScheme == .light ? Color.accentColor : .white.opacity(0.3))
                        .padding(5)
                }
                .opacity(zoomed ? 0 : 1)
        }
    }
}

struct GfroerliMapAnnotationPin: View {
    @Environment(\.colorScheme) var colorScheme

    let location: Location

    var color: Color {
        location.isActive ? Color.accentColor : Color.gray
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(color, lineWidth: 2)
                .background(Circle().fill(color.opacity(colorScheme == .light ? 0.5 : 0.8)))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white, colorScheme == .light ? Color.accentColor : .white.opacity(0.3))
                        .padding(5)
                }
        }
    }
}

// MARK: - Preview

struct GfroerliMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GfroerliMapAnnotation(zoomed: Binding.constant(true), location: Location.exampleLocation())
            GfroerliMapAnnotationPin(location: Location.exampleLocation())
        }
    }
}
