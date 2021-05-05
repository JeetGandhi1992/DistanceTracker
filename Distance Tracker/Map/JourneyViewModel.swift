//
//  JourneyViewModel.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 6/4/21.
//

import Foundation
import Combine
import CoreLocation


class JourneyViewModel: NSObject, ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var locationList: [CLLocationCoordinate2D] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    var distance = Measurement(value: 0, unit: UnitLength.meters) {
        willSet {
            objectWillChange.send()
        }
    }
    
    private var run: Run?
    let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    
    
    var lastKnownLocation: CLLocationCoordinate2D?
    
    func start() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    func end() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension JourneyViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: CLLocation(latitude: lastLocation.latitude,
                                                                  longitude: lastLocation.longitude))
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            locationList.append(newLocation.coordinate)
        }
        print(locationList.count)
    }
}
