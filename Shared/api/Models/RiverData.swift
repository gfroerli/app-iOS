//
//  River.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import Foundation
import MapKit

struct River: Identifiable {
    var id: String
    var name: String
    var sensors: [String]
    var region: MKCoordinateRegion
}

let limmat = River(
    id: UUID().uuidString,
    name: "Limmat",
    sensors: ["0"],
    region: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.38668, longitude: 8.53218),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
)

let rhein = River(
    id: UUID().uuidString,
    name: "Rhine",
    sensors: [],
    region: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.56151, longitude: 7.58901),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
)

let rivers: [River] = [limmat, rhein]
