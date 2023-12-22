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

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "thermometer.medium")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .white, tintColor())
                
                Text(location.name ?? "")
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
            .background(backgroundColor())
            .border(tintColor(), width: 2)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(tintColor(), lineWidth: 2)
            }
            .opacity(zoomed ? 1 : 0)
            
            Circle()
                .strokeBorder(tintColor(), lineWidth: 2)
                .background(Circle().fill(backgroundColor()))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white, tintColor())
                        .padding(5)
                }
                .opacity(zoomed ? 0 : 1)
        }
    }
    
    private func tintColor() -> Color {
        if colorScheme == .light {
            if location.isActive {
                Color.accentColor
            }
            else {
                Color.gray
            }
        }
        else {
            if location.isActive {
                Color.white.opacity(0.3)
            }
            else {
                Color.gray
            }
        }
    }
        
    private func backgroundColor() -> Color {
        if colorScheme == .light {
            if location.isActive {
                Color.accentColor.opacity(0.5)
            }
            else {
                Color.gray.opacity(0.5)
            }
        }
        else {
            if location.isActive {
                Color.accentColor.opacity(0.5)
            }
            else {
                Color.gray.opacity(0.5)
            }
        }
    }
}

// MARK: - Preview

struct GfroerliMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GfroerliMapAnnotation(zoomed: Binding.constant(true), location: Location.exampleLocation())
        }
    }
}
