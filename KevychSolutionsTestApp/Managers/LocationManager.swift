//
//  LocationManager.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var latitude: Double? = nil
    @Published var longitude: Double? = nil
    
    @Published var showAlert: Bool? = false

    override init() {
        super.init()
        authorizationStatus()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func authorizationStatus() {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            showAlert = true
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            showAlert = false
        case .notDetermined:
            showAlert = nil
        @unknown default:
            print("new value")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}


