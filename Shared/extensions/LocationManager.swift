//
//  LocationManager.swift
//  LocationManager
//
//  Created by Marc Kramer on 14.08.21.
//
import CoreLocation
import CoreLocationUI
import MapKit

final class ObservableLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    static let defaultDistance: CLLocationDistance = 1000000

    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 46.7985, longitude: 8.2318),
            latitudinalMeters: ObservableLocationManager.defaultDistance,
            longitudinalMeters: ObservableLocationManager.defaultDistance
        )
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func updateLocation() {
        locationManager.requestLocation()
        
        while locationManager.location == nil {
            
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: self.locationManager.location!.coordinate,
                latitudinalMeters: 20000,
                longitudinalMeters: 20000
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       return
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error handling
        print(error.localizedDescription)
    }
}
