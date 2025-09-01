//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Alin Postolache on 09.05.2025.
//

import CoreLocation
import Combine
@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters   // battery-friendly
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()   // 👉 only one callback, then it stops
    }

    // Called once (maybe twice if GPS refines the fix)
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        print("location1")
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }

}
import CoreLocation
import SwiftUI
import Combine

@MainActor
final class LocationPickerViewModel: ObservableObject {
    @Published var options: [LocationOption] = []
    @Published var selected: LocationOption?
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManager ) {
        // 1.  Seed with “Current Location” once we have it
        // 1.  Seed with “Current Location” once we have it
        print("location2")
        // 1️⃣  If a fix already exists, add it immediately
        if let loc = locationManager.location {
            insertCurrentLocation(loc)
        }

        // 2️⃣  Keep listening for future updates
        locationManager.$location
            .compactMap { $0 }                 // ignore nils
            .sink { [weak self] loc in
                self?.insertCurrentLocation(loc)
            }
            .store(in: &cancellables)
    }
    private func insertCurrentLocation(_ loc: CLLocation) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(loc) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let city = placemarks?.first?.locality {
                let locationName = city
                let current = LocationOption(name: locationName, coordinate: loc)

                if let idx = self.options.firstIndex(where: { $0.name == "Current Location" || $0.coordinate == loc }) {
                    self.options[idx] = current
                } else {
                    self.options.insert(current, at: 0)
                }

                self.selected = current
            } else {
                // fallback if city not found
                let current = LocationOption(name: "Current Location", coordinate: loc)
                if let idx = self.options.firstIndex(where: { $0.name == "Current Location" || $0.coordinate == loc }) {
                    self.options[idx] = current
                } else {
                    self.options.insert(current, at: 0)
                }

                self.selected = current
            }
        }
    }

}
/// A display-ready wrapper you can bind to a Picker.
struct LocationOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocation
}
