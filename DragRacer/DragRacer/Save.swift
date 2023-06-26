//
//  Save.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/26/23.
//

import Foundation
import LocationFormatter
import CoreLocation

struct Save: Identifiable {
    let id = UUID()
    
    // MARK: General information
    let driverName: String
    let vehicleName: String
    let date: Date
    
    // MARK: Location details
    let locationDescription: String
    let latitude: Double
    let longitude: Double
    let forecastTemperature: Double // Fahrenheit, since it needs less significant figures to be accurate (especially when getting weather from an online API)
    let forecastSky: String // cloudy/sunny, etc.
    // TODO: this commented out weather data:
    //let windDirection: String
    //let windSpeed: String
    let humidity: Double
    let atmosphericPressure: Double // Kilopascals, since it needs less significant figures than inHg and also is the default for CMAltitudeData.pressure: https://developer.apple.com/documentation/coremotion/cmaltitudedata/1616152-pressure
    
    // MARK: Race details
    // Speed units are meters per second, converted when displayed, since CLLocation.speed is in meters per second: https://developer.apple.com/documentation/corelocation/cllocation/1423798-speed
    let reactionTime: Double
    let _0to60Time: Double
    let _330ftTime: Double
    let eighthMileTime: Double
    let eighthMileSpeed: Double
    let _1000ftTime: Double
    let quarterMileTime: Double
    let quarterMileSpeed: Double
    let wasOnDragStrip: Bool // TODO: do we need this? it was in the old version of the app
    
    // MARK: TableView-related items
    let section: String
    
    static let example = Save(driverName: "Ethan Mayer", vehicleName: "1969 Chevrolet Camaro Z/28", date: Date(), locationDescription: "Byhalia, MS", latitude: 0, longitude: 0, forecastTemperature: 75, forecastSky: "Cloudy", humidity: 0, atmosphericPressure: 0, reactionTime: 0, _0to60Time: 0, _330ftTime: 0, eighthMileTime: 0, eighthMileSpeed: 0, _1000ftTime: 0, quarterMileTime: 0, quarterMileSpeed: 0, wasOnDragStrip: false, section: "Saves")
}

extension Save: CustomStringConvertible {
    var dayDateDescription: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMMdyyyy", options: 0, locale: Locale.current)
//        return formatter.string(from: date)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    var timeDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    var dateDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    var description: String {
        return "\(dateDescription) with \(vehicleName)"
    }
    
    var latitudeLongitudeDescription: String {
        // https://swiftpackageindex.com/salishseasoftware/LocationFormatter
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let formatter = LocationCoordinateFormatter()
        
//        // Decimal Degrees (DD)
//        formatter.format = .decimalDegrees
//        let res = formatter.string(from: coordinate) // "48.11638° N, 122.74231° W"
        
        // Degrees Minutes Seconds (DMS)
        formatter.format = .degreesMinutesSeconds
        let res = formatter.string(from: coordinate) // "48° 6' 59" N, 122° 46' 31" W"
        
        guard let res = res else {
            logger.log(level: .warning, message: "Failed to convert latitude and longitude to string. Returning backup method.")
            return "\(latitude), \(longitude)"
        }
        
        return res
    }
    
    var forecastTemperatureDescription: String {
        let temperature = Measurement<UnitTemperature>(value: forecastTemperature, unit: .fahrenheit)
        //return temperature.formatted()
        
        let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(width: .abbreviated, locale: .current)
        return temperatureStyle.format(temperature)
    }
    
    var humidityDescription: String {
        // https://stackoverflow.com/questions/57618174/how-to-format-decimal-in-swift-to-percentage
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        let res = formatter.string(from: NSNumber(value: humidity))
        
        guard let res = res else {
            logger.log(level: .warning, message: "Failed to convert humidity to percentage. Returning backup method.")
            return String(format: "%.2f%", humidity * 100.0)
        }
        
        return res
    }
    
    var atmosphericPressureDescription: String {
        let pressure = Measurement<UnitPressure>(value: atmosphericPressure, unit: .kilopascals)
        //return pressure.formatted()
        
        let pressureStyle = Measurement<UnitPressure>.FormatStyle(width: .abbreviated, locale: .current)
        
        let converted = pressure.converted(to: .inchesOfMercury)
        return pressureStyle.format(converted)
    }
    
    func decimalFormatGeneral(_ value: Double, _ description: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.maximumFractionDigits = 2
        let res = formatter.string(from: NSNumber(value: value))
        
        guard let res = res else {
            logger.log(level: .warning, message: "Failed to convert \(description) to decimal. Returning backup method.")
            return String(format: "%f", value)
        }
        
        return res
    }
    
    func decimalFormatSeconds(_ value: Double) -> String {
        let time = Measurement<UnitDuration>(value: atmosphericPressure, unit: .seconds)
        let timeStyle = Measurement<UnitDuration>.FormatStyle(width: .abbreviated, locale: .current)
        return timeStyle.format(time)
    }
    
    func decimalFormatMph(_ value: Double) -> String {
        let speed = Measurement<UnitSpeed>(value: atmosphericPressure, unit: .metersPerSecond)
        let speedStyle = Measurement<UnitSpeed>.FormatStyle(width: .abbreviated, locale: .current)
        let converted = speed.converted(to: .milesPerHour)
        return speedStyle.format(converted)
    }
    
    var reactionTimeDescription: String {
        return decimalFormatSeconds(reactionTime)
    }
    var _0to60TimeDescription: String {
        return decimalFormatSeconds(_0to60Time)
    }
    var _330ftTimeDescription: String {
        return decimalFormatSeconds(_330ftTime)
    }
    var eighthMileTimeDescription: String {
        return decimalFormatSeconds(eighthMileTime)
    }
    var eighthMileSpeedDescription: String {
        return decimalFormatMph(eighthMileSpeed)
    }
    var _1000ftTimeDescription: String {
        return decimalFormatSeconds(_1000ftTime)
    }
    var quarterMileTimeDescription: String {
        return decimalFormatSeconds(quarterMileTime)
    }
    var quarterMileSpeedDescription: String {
        return decimalFormatMph(quarterMileSpeed)
    }
}
