//
//  GPS.swift
//  DragRacer
//
//  Created by Ethan Mayer and Sebastian Bond on 6/13/19.
//  Copyright © 2019 Ethan Mayer and Sebastian Bond. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPSDelegate: class {
    func get60mphTime(time: UInt64)
    func get330ftTime(time: UInt64)
    func getOneEigthMileTime(time: UInt64)
    func getOneEigthMileSpeed(speed: CLLocationSpeed)
    func get1000ftTime(time: UInt64)
    func getOneFourthMileTime(time: UInt64)
    func getOneFourthMileSpeed(speed: CLLocationSpeed)
    func getDistanceTraveledPercentage(percentage: NSNumber)
}

class GPS: NSObject, CLLocationManagerDelegate {
    
    //Initialize GPS API
    let locationManager = CLLocationManager()
    var bestRadiusSoFar: CLLocationAccuracy = CLLocationAccuracy.greatestFiniteMagnitude
    
    var originalLocation: CLLocation? = nil //Starting location
    var originalLocationPlacemark: CLPlacemark? = nil //Starting location's geolocater placemark
    var latitude: CLLocationDegrees? = nil //Latitude of the location in degrees
    var longitude: CLLocationDegrees? = nil //Longitude of location in degrees
    var accurate = false
    
    let epsilon = 0.1
    let Mph60_mps = Measurement(value: 60.0, unit: UnitSpeed.milesPerHour).converted(to: UnitSpeed.metersPerSecond).value // 60mph in m/s
    let Ft330_m = Measurement(value: 330.0, unit: UnitLength.feet).converted(to: UnitLength.meters).value // 330ft in m
    let MiOneEighth_m = Measurement(value: 0.125, unit: UnitLength.miles).converted(to: UnitLength.meters).value // 1/8th mi in m
    let Ft1000_m = Measurement(value: 1000.0, unit: UnitLength.feet).converted(to: UnitLength.meters).value // 1000ft in m
    let MiOneFourth_m = Measurement(value: 0.25, unit: UnitLength.miles).converted(to: UnitLength.meters).value // 1/4th mi in m
    
    var distance: CLLocationDistance = 0
    
    var race: RaceOptions!
    
    //Initialize GPS Delegate
    weak var delegate: GPSDelegate?
    init(delegate: GPSDelegate) {
        self.delegate = delegate
    }
    
    //Get GPS location data
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        //Check if user has authorized the app to use location services
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        // Configure location service
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone  //Notified of all movements
        locationManager.delegate = self
        
        //Start location service
        locationManager.startUpdatingLocation()
    }
    
    //Stop getting GPS location data
    func stopReceivingLocationChanges() {
        locationManager.stopUpdatingLocation()
    }
    
    func setRaceOptions(raceOptions: RaceOptions) {
        race = raceOptions
    }
    
    //Handle getting location data
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations: [CLLocation]) {
        let lastLocation = didUpdateLocations.last!

        print("Current and new best: \(lastLocation.horizontalAccuracy) meter radius")
            
        if (lastLocation.horizontalAccuracy <= 10) { //Radius of 10 meter radius is acceptable as accurate
            if !accurate {
                accurate = true
                self.originalLocation = lastLocation
                self.latitude = lastLocation.coordinate.latitude
                self.longitude = lastLocation.coordinate.longitude
                //print("Best accuracy: \(bestRadiusSoFar) meter radius.")
                
                //Use CLGeocoder to find the address of the current location
                if let lastLocation = self.locationManager.location {
                    let geocoder = CLGeocoder()
                        
                    // Look up the location and pass it to the completion handler
                    geocoder.reverseGeocodeLocation(lastLocation,
                                completionHandler: { (placemarks, error) in
                        if error == nil {
                            let firstLocation = placemarks?[0]
                            self.originalLocationPlacemark = firstLocation
                            //print(firstLocation as Any)
                            //completionHandler(firstLocation)
                        } else {
                         // An error occurred during geocoding.
                            //completionHandler(nil)
                        }
                    })
                }
            } else {
                if (locationManager.location!.speed > 0) {
                    var finishObjective: Double = 0
                    
                    //MARK: TODO: Refactor
                    //Check to see which objective the user selected as the final race objective
                    if (race.contains(.ft330)) {
                        finishObjective = Ft330_m
                    } else if (race.contains(.miOneEightTime) || race.contains(.miOneEightSpeed)) {
                        finishObjective = MiOneEighth_m
                    } else if (race.contains(.ft1000)) {
                        finishObjective = Ft1000_m
                    } else if (race.contains(.miOneFourthTime) || race.contains(.miOneFourthSpeed)) {
                        finishObjective = MiOneFourth_m
                    }
                    
                    //Notify the race of the current distance from the end of the race
                    delegate?.getDistanceTraveledPercentage(percentage: NSNumber(value: locationManager.location!.distance(from: originalLocation!) / finishObjective))
                }
                
                //Check for 60mph
                if (locationManager.location!.speed - Mph60_mps < epsilon && locationManager.location!.speed - Mph60_mps > 0 && race.contains(.mph60)) {
                    //Notify the race of the time 60mph was reached
                    delegate?.get60mphTime(time: clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW))
                    race.subtract(.mph60)
                }
                
                //Check for 330ft
                if (locationManager.location!.distance(from: originalLocation!) - Ft330_m < epsilon && locationManager.location!.distance(from: originalLocation!) - Ft330_m > 0 && race.contains(.ft330)) {
                    //Notify the race of the time 330ft was reached
                    delegate?.get330ftTime(time: clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW))
                    race.subtract(.ft330)
                }
                
                //Check for 1/8th mile
                if (locationManager.location!.distance(from: originalLocation!) - MiOneEighth_m < epsilon && locationManager.location!.distance(from: originalLocation!) - MiOneEighth_m > 0 && (race.contains(.miOneEightTime) || race.contains(.miOneEightSpeed))) {
                    //Notify the race of the time 1/8th mile was reached
                    if (race.contains(.miOneEightTime)) {
                        delegate?.getOneEigthMileTime(time: clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW))
                        race.subtract(.miOneEightTime)
                    //Notify the race of the speed 1/8th mile was reached
                    } else if (race.contains(.miOneEightSpeed)) {
                        delegate?.getOneEigthMileSpeed(speed: locationManager.location!.speed)
                        race.subtract(.miOneEightSpeed)
                    }
                }
                
                //Check for 1000ft
                if (locationManager.location!.distance(from: originalLocation!) - Ft1000_m < epsilon && locationManager.location!.distance(from: originalLocation!) - Ft1000_m > 0 && race.contains(.ft1000)) {
                    //Notify the race of the time 1000ft was reached
                    delegate?.get1000ftTime(time: clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW))
                    race.subtract(.ft1000)
                }
                
                //Check for 1/4th mile
                if (locationManager.location!.distance(from: originalLocation!) - MiOneFourth_m < epsilon && locationManager.location!.distance(from: originalLocation!) - MiOneFourth_m > 0 && (race.contains(.miOneFourthTime) || race.contains(.miOneFourthSpeed))) {
                    //Notify the race of the time 1/4th mile was reached
                    if (race.contains(.miOneFourthTime)) {
                        delegate?.getOneFourthMileTime(time: clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW))
                        race.subtract(.miOneFourthTime)
                    //Notify the race of the speed 1/4th mile was reached
                    } else if (race.contains(.miOneFourthSpeed)) {
                        delegate?.getOneFourthMileSpeed(speed: locationManager.location!.speed)
                        race.subtract(.miOneFourthSpeed)
                    }
                }
            }
        }
    }
    
    //Error handling for locationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
        print(error)
    }
}
