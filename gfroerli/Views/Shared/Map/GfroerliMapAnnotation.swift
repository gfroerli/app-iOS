//
//  MapAnnotation.swift
//  gfroerli
//
//  Created by Marc on 02.09.22.
//

import SwiftUI
import GfroerliAPI
import MapKit

struct GfroerliMapAnnotation: View {
    let location: Location
    var body: some View {
        HStack {
            Image(systemName: "thermometer.medium")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .white, .blue)
                .padding(.leading, 6)
            Text(location.name)
            Text(location.latestTemperatureString)
            Image(systemName: "chevron.right")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
        .foregroundColor(.white)
        .padding(5)
        .background(.blue.opacity(0.4))
        .border(.blue, width: 2)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .strokeBorder(.blue, lineWidth: 2)
        }
    }
}

struct GfroerliMapAnnotationPin: View {
    let location: Location
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(.blue, lineWidth: 2)
                .background(Circle().fill(.blue.opacity(0.4)))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white, .blue)
                        .padding(5)
                }
            
        }
    }
}

struct GfroerliMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        GfroerliMapAnnotation(location: Location.exampleLocation())
        GfroerliMapAnnotationPin(location: Location.exampleLocation())
    }
}
