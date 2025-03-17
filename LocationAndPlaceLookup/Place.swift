//
//  Place.swift
//  LocationAndPlaceLookup
//
//  Created by Christian Manzaraz on 17/03/2025.
//

import Foundation
import MapKit
import Contacts

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: Double {
        self.mapItem.placemark.coordinate.longitude
    }
    
    var address: String {
        // Make sure you import Contacts to use "CN" structures
        let postalAddress = mapItem.placemark.postalAddress ?? CNPostalAddress()
        // Get String that is a multiline formatted postal address
        var address = CNPostalAddressFormatter().string(from: postalAddress)
        // Remove line feeds from multiline String above
        address = address.replacingOccurrences(of: "\n", with: ", ")
        
        return address
    }
    
    
}
