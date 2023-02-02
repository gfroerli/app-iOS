//
//  MapAnnotation.swift
//  gfroerli
//
//  Created by Marc on 02.09.22.
//

import GfroerliAPI
import MapKit
import SwiftUI

struct GfroerliMapAnnotation: View {
    
    let location: Location
    
    var body: some View {
        HStack {
            Image(systemName: "thermometer.medium")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .white, Color.accentColor)
            
            Text(location.name)

            Text(location.latestTemperatureString)

            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .fontWeight(AppConfiguration.MapView.fontWeight)
        .foregroundColor(.white)
        .padding(8)
        .background(Color.accentColor.opacity(0.5))
        .border(Color.accentColor, width: 2)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .strokeBorder(Color.accentColor, lineWidth: 2)
        }
    }
}

struct GfroerliMapAnnotationPin: View {
    
    let location: Location
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.accentColor, lineWidth: 2)
                .background(Circle().fill(Color(UIColor.tintColor).opacity(0.5)))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white, Color.accentColor)
                        .padding(5)
                }
        }
    }
}

struct GfroerliMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GfroerliMapAnnotation(location: Location.exampleLocation())
            GfroerliMapAnnotationPin(location: Location.exampleLocation())
        }
    }
}