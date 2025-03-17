//
//  LocationManager.swift
//  LocationAndPlaceLookup
//
//  Created by Christian Manzaraz on 17/03/2025.
//

import Foundation
import MapKit
import SwiftUI

@Observable

class LocationManager: NSObject, CLLocationManagerDelegate {
    //*** CRITICALLY IMPORTANT*** Allways add info.list message for Privacy-Location when usage description
    // You must add an entry in the "info" tab fo the project file for "Privacy-Lcoation When In Use Usage Descrition.
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Get a region around current location with specified radius in meters
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 50_000) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
    }
}

// Delegate methods that Apple has created & will call, but that we filled out
extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return } // Use the last location as the location
        
        location = newLocation
        
        // You can uncomment this when you only want to get the location once, not repeatedly
//        manager.stopUpdatingLocation()
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("LocationManager authorization granted.")
            manager.startUpdatingLocation()
        
        case .denied, .restricted:
            print("LocationManager authorization deined.")
            errorMessage = "😡📍LocationManager accessed deined."
            manager.stopUpdatingLocation()
            
        case .notDetermined:
            print("LocationManager authorizaiton not determined.")
            manager.requestWhenInUseAuthorization()
        
        @unknown default: // @unknown matches any value. The main difference is that the compiler will produce a waring if all known elements of the enum have not yet been matched. New enum cases remain source-compatible as a result of throwing a warning insted of an error
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("😡🗺️ ERROR LocationManager: \(errorMessage ?? "n/a")")
    }
    
}
