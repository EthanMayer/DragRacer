//
//  Barometer.swift
//  DragRacer
//
//  Created by Ethan Mayer and Sebastian Bond on 6/13/19.
//  Copyright © 2019 Ethan Mayer and Sebastian Bond. All rights reserved.
//

import Foundation
import CoreMotion
import PromiseKit

class Barometer {
    
    //Initialize pressure sensor
    let altimeter = CMAltimeter()
    
    var inchesOfMercury = 0.0

    //Get the current pressure from the barometer
    func getPressure() -> Promise<Double> {
        return Promise { seal in
            if CMAltimeter.isRelativeAltitudeAvailable() {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                    //MARK: TODO: Use for < iOS13?
                    //Native data is in units of kPa
                    //let kilopascals = (data?.pressure.floatValue)!
                    //Convert data to US standard pressure units of inHg
                    //1 atm = 101.325 kPa | 101,325 Pa = 29.92 inHg
                    //let inchesOfMercury = kilopascals / 101.325 * 29.92 //inHg
                    
                    //If there is no error, proceed
                    if (error == nil) {
                        //Get pressure in inHg
                        self.inchesOfMercury = Measurement(value: (data?.pressure.doubleValue)!, unit: UnitPressure.kilopascals).converted(to: .inchesOfMercury).value //MARK: TODO: convert when displaying, and save original value; display it based on a setting.
                        print(String(self.inchesOfMercury))
                        
                        //Stop receiving updates after the pressure has been recorded
                        self.altimeter.stopRelativeAltitudeUpdates()
                        seal.fulfill(self.inchesOfMercury)
                    } else {
                        seal.reject(error!)
                    }
                }
            }
        }
    }
}
