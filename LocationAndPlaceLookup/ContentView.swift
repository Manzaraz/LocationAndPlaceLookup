//
//  ContentView.swift
//  LocationAndPlaceLookup
//
//  Created by Christian Manzaraz on 14/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    @State private var sheetIsPresented = false
    
    
    var body: some View {
        VStack {
            Text("\(locationManager.location?.coordinate.latitude ?? 0.0), \(locationManager.location?.coordinate.longitude ?? 0.0)")
            let _ = print("\(locationManager.location?.coordinate.latitude ?? 0.0), \(locationManager.location?.coordinate.longitude ?? 0.0)")
            
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
        .sheet(isPresented: $sheetIsPresented) {
            PlaceLookupView(locationManager: locationManager)
        }
    }
}

#Preview {
    ContentView()
}
