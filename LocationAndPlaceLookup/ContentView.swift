//
//  ContentView.swift
//  LocationAndPlaceLookup
//
//  Created by Christian Manzaraz on 14/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    @State var selectedPlace: Place?
    @State private var sheetIsPresented = false
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(selectedPlace?.name ?? "n/a")
                    .font(.title2)
                Text(selectedPlace?.address ?? "n/a")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("\(selectedPlace?.latitude ?? 0.0),\(selectedPlace?.longitude ?? 0.0)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
            }
            Spacer()
            
            Button {
                sheetIsPresented.toggle()
            } label: {
                Image(systemName: "location.magnifyingglass")
                Text("Location Search")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .font(.title2)

            
        }
        .padding()
        .task {
            // get user location once when the view appears
            // Handle case if user already authorized location use
            if let location = locationManager.location {
                selectedPlace = await Place(location: location)
            }
            
            // Setup a location callback - this handles when new locations come in after the app launches - it will catch the first locationUpdate, which is what we need, otherwhise we won't see the information in the VStack update after the user first authorizes location use.
            locationManager.locationUpdated = { location in // <- Not an async task
                // We know we now have a new location, so use it to update the selectedPlace.
                Task { // <- So we make it one with Task
                    selectedPlace = await Place(location: location)
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            PlaceLookupView(locationManager: locationManager, selectedPlace: $selectedPlace)
        }
    }
}

#Preview {
    ContentView()
}
