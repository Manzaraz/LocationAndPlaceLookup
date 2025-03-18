//
//  PlaceLookupView.swift
//  LocationAndPlaceLookup
//
//  Created by Christian Manzaraz on 17/03/2025.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    let locationManager: LocationManager // Passed in from the parent View
    @Binding var selectedPlace: Place? // Passed in from the parent View
    @State var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var searchRegion = MKCoordinateRegion()
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView("No Results", systemImage: "mappin.slash")
                } else {
                    List(placeVM.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.title2)
                            
                            Text(place.address)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            selectedPlace = place
                            dismiss()
                        }
                    }
                    .listStyle(.plain)
                }
                
            }
            .navigationTitle("Location Search")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
            }
        }
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .onAppear { // Only need to get searchRegion when View appears
            searchRegion = locationManager.getRegionAroundCurrentLocation() ?? MKCoordinateRegion()
        }
        .onDisappear {
            searchTask?.cancel() // Cancel anyu outstanding Task when the View dismisses
        }
        .onChange(of: searchText) { oldValue, newValue in
            searchTask?.cancel() // Stop any existing Tasks that haven't been completed
            
            guard !newValue.isEmpty else {
                placeVM.places.removeAll()
                return
            }
            
            // Create a new search task
            searchTask = Task {
                do {
                    // Wait 300ms before running the current task. any typing befor the Task has run cancels the old task. this prev ents searches happening quiclky, if a user types fast, and will reduce chances that Apple cuts off search because too many searches too quickly
                    try await Task.sleep(for: .milliseconds(300))
                    
                    // Check if task was called during sleep - if so, return & wait for new Task to run, or more typing to happen
                    if Task.isCancelled { return }
                    
                    // Verify search text hasn't changed during delay
                    if searchText == newValue {
                        try await placeVM
                            .search(text: newValue, region: searchRegion)
                    }
                } catch {
                    if !Task.isCancelled {
                        print("😡ERROR: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }
}

#Preview {
    PlaceLookupView(locationManager: LocationManager(), selectedPlace: .constant(Place(mapItem: MKMapItem())))
}
