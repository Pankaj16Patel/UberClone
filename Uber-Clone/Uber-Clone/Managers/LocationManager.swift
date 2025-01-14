//
//  LocationManager.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import Foundation
import CoreLocation

class LocationManger: NSObject , ObservableObject {
    
    private let locationManager = CLLocationManager()
   static let shared = LocationManger()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManger: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        self.userLocation = location.coordinate
        locationManager.stopUpdatingLocation()
     //   print(locations.first)
    }
   
}

