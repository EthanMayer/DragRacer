//
//  Barometer.swift
//  DragRacer
//
//  Created by Ethan Mayer and Sebastian Bond on 6/13/19.
//  Copyright © 2019 Ethan Mayer and Sebastian Bond. All rights reserved.
//

import Foundation
import CoreMotion
import Combine
import SwiftUILogger

class Barometer {
    
    // Initialize pressure sensor
    let altimeter = CMAltimeter()
    
    var pressure = 0.0

    // Get the current pressure from the barometer, return as Future
    func getPressure() -> Future<Double, Error> {
        return Future<Double, Error> { promise in
            
            // Proceed async
            DispatchQueue.main.async {
        
                // Check if altimeter is working
                if CMAltimeter.isRelativeAltitudeAvailable() {
                    
                    // Check authorization status of altimeter
                    switch CMAltimeter.authorizationStatus() {
                        case .notDetermined: // Handle state before user prompt
                            logger.log(level: .info, message: "Altimiter authorization undetermined") //MARK: TODO: .debug
                        case .restricted: // Handle system-wide restriction
                           fatalError("Altimeter authorization restricted")
                        case .denied: // Handle user denied state
                            fatalError("Altimeter authorization denied")
                        case .authorized: // Ready to go!
                            logger.log(level: .info, message: "Altimeter authorized") //MARK: TODO: .debug
                        @unknown default:
                            fatalError("Unknown authorization status")
                    }
                    
                    // Start receiving altitude from altimeter
                    self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                        
                        // If there is a non-nil error, return with promise as failure
                        if let error = error {
                            promise(.failure(error))
                            
                        // If there is no error, proceed
                        } else {
                            
                            // Get pressure in inHg
                            self.pressure = Measurement(value: (data?.pressure.doubleValue)!, unit: UnitPressure.kilopascals)/*.converted(to: .inchesOfMercury)*/.value
                            
                            logger.log(level: .info, message: "Pressure: " + String(self.pressure)) //MARK: TODO: .debug
                            
                            // Stop receiving updates after the pressure has been recorded
                            self.altimeter.stopRelativeAltitudeUpdates()
                            
                            // Return value with promise as success
                            promise(.success(self.pressure))
                        }
                    }
                }
            }
        }
    }
}
