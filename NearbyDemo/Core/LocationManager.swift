//
//  LocationManager.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static var instance = LocationManager()
    private var location: CLLocation?
    private let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func askLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        print(location)
        return location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if  manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            print("Please provide location to get nearby data")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
