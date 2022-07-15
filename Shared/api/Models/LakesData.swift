//
//  LakesData.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import Foundation
import MapKit

struct Lake: Identifiable {
    var id: String
    var name: String
    var sensors: [Int]
    var region: MKCoordinateRegion
}

let lakeOfZurich = Lake(
    id: UUID().uuidString,
    name: NSLocalizedString("Lake of Zurich", comment: ""),
    sensors: [1,6],
    region: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.28073, longitude: 8.72869),
        span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
    )
)

let lakeOfLucerne = Lake(
    id: UUID().uuidString,
    name: "Lake of Lucerne",
    sensors: [],
    region: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.99728, longitude: 8.43128),
        span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
    )
)

let lakes: [Lake] = [lakeOfZurich]
