////
////  Weather.swift
////  DragRacer
////
////  Created by Ethan Mayer and Sebastian Bond on 6/17/19.
////  Copyright © 2019 Ethan Mayer and Sebastian Bond. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//
//class Weather {
//    let formatter = ISO8601DateFormatter()
//    
//    //Request JSON files from weather API URLs
//    //TODO: potentially pass an error handler lambda
//    static func getJSON(_ url: URL, _ processJSON: @escaping ([String: Any]) -> Error?,
//                        errorHandler: @escaping WeatherHandler) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        //Grab first forecast JSON
//        let session = URLSession(configuration: .default)
//        session.dataTask(with: request, completionHandler: { (data, response, error) in
//            if let error = error {
//                errorHandler(nil, error)
//                return
//            }
//            
//            //Parse JSON file received
//            let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
//            if let dictionary = jsonResponse as? [String: Any] {
//                let error = processJSON(dictionary)
//                if let error = error {
//                    errorHandler(nil, error)
//                    return
//                }
//            }
//            else {
//                errorHandler(nil, RuntimeError("JSON is malformed"))
//                return
//            }
//        }).resume()
//    }
//    
//    struct WeatherPropertyEntry {
//        func getValue() -> Any? {
//            return valuePackage["value"]
//        }
//        func getTime() -> String {
//            return valuePackage["validTime"] as! String
//        }
//        @inline(__always) static func tryGetTime(jsonObj: [String: Any]) throws -> String {
//            return try unwrap(jsonObj["validTime"] as? String)
//        }
//        var valuePackage: [String: Any]
//    }
//    
//    struct WeatherResult {
//        var temperature: Measurement<UnitTemperature>! //farenheight
//        var humidity: Int! //percent
//        var cloudCoverage: Int! //percent
//        var forecast: String!
//        var rainChance: Int! //percent
//    }
//    
//    typealias WeatherHandler = (WeatherResult?, Error?) -> Void
//    
//    func extractFromJSON(jsonPropertiesObj properties: [String: Any], propertyToExtract: String, uom: String) throws -> WeatherPropertyEntry? {
//        let property = try unwrap(properties[propertyToExtract] as? [String: Any])
//        let uomFound = try unwrap(property["uom"] as? String) //unit of measurement seems to be what "uom" stands for in the JSON. Verify this is celsius as a "sanity check."
//        guard uomFound == uom else {
//            return nil
//        }
//        
//        let values = try unwrap(property["values"] as? [[String: Any]])
//        let currentTime = Date()
//        var minTimeDistance: TimeInterval = TimeInterval.greatestFiniteMagnitude
//        var closest_: [String: Any]? = nil
//        for obj in values {
//            let validTime = try WeatherPropertyEntry.tryGetTime(jsonObj: obj)
//            if let valueTime = formatter.date(from: validTime) {
//                let timeInterval = valueTime.timeIntervalSince(currentTime)
//                let timeDistance = abs(timeInterval)
//                if timeDistance < minTimeDistance {
//                    minTimeDistance = timeDistance
//                    closest_ = obj
//                }
//            }
//        }
//        
//        guard let closest = closest_ else { return nil }
//        return WeatherPropertyEntry(valuePackage: closest)
//    }
//    
//    func debugTimeStr(_ temperatureEntry: WeatherPropertyEntry) {
//        let timeStr = temperatureEntry.getTime()
//        guard let time = self.formatter.date(from: timeStr) else { print("Error making string from time"); return }
//        let timestampLocalTime = DateFormatter.localizedString(from: time, dateStyle: .medium, timeStyle: .short)
//        print("\(timeStr)   -   \(timestampLocalTime)") //TODO: maybe round down the time?
//    }
//    
//    //Get and parse weather JSON
//    func getWeatherJSON(location: CLLocation, completionHandler: @escaping WeatherHandler) {
//        //Insert current coordinates into weather API URL
//        let urlStr = String.init(format: "https://api.weather.gov/points/%.15f,%.15f", location.coordinate.latitude, location.coordinate.longitude) //40.814780,-73.035526   ->  -73.044652999999997, 40.812373000000001
//        print(urlStr)
//        //Check to make sure URL is valid
//        guard let url = URL(string: urlStr) else {
//            completionHandler(nil, RuntimeError("Invalid URL"))
//            return
//        }
//        
//        //Parse first JSON file for hourly forecast URL
//        let error_jsonFormat = RuntimeError("JSON is not formatted as expected")
//        let error_units = RuntimeError("Incorrect units reported in JSON")
//        Weather.getJSON(url, { (dictionary) in
//            guard let nestedDictionary = dictionary["properties"] as? [String: Any] else {
//                return error_jsonFormat
//            }
//            
//            let urlAny = nestedDictionary["forecastGridData"]
//            
//            guard let urlStr = urlAny as? String else {
//                return error_jsonFormat
//            }
//            guard let url = URL(string: urlStr) else {
//                return RuntimeError("Invalid URL in JSON")
//            }
//            
//            //Parse second JSON file for temperature
//            Weather.getJSON(url, { (dictionary) in
//                print(url)
//                
//                //Only for forecastHourly: Extract the first period because it's the one that we're in.
//                //forecastHourly method: properties(dict) -> periods(array) -> temperature(int)
//                
//                //forecastGridData method: properties(dict) -> temperature(dict) -> values(array of dict) ->
//                
//                //Search for temperature and humidity
//                var weatherResult = WeatherResult()
//                do {
//                    let properties = try unwrap(dictionary["properties"] as? [String: Any])
//                    
//                    //MARK: Temperature
//                    guard let temperatureEntry = try self.extractFromJSON(jsonPropertiesObj: properties, propertyToExtract: "temperature", uom: "wmoUnit:degC") else {
//                        return error_units
//                    }
//                    guard let temperatureCelsius = temperatureEntry.getValue() as? Double else {
//                        return error_jsonFormat
//                    }
//                    self.debugTimeStr(temperatureEntry)
//                    weatherResult.temperature = Measurement(value: temperatureCelsius, unit: UnitTemperature.celsius)
//                    
//                    //MARK: Humidity
//                    guard let humidityEntry = try self.extractFromJSON(jsonPropertiesObj: properties, propertyToExtract: "relativeHumidity", uom: "wmoUnit:percent") else {
//                        return error_units
//                    }
//                    self.debugTimeStr(humidityEntry)
//                    weatherResult.humidity = humidityEntry.getValue() as? Int
//                    
//                    //MARK: Skycover
//                    guard let skyCoverEntry = try self.extractFromJSON(jsonPropertiesObj: properties, propertyToExtract: "skyCover", uom: "wmoUnit:percent") else {
//                        return error_units
//                    }
//                    self.debugTimeStr(skyCoverEntry)
//                    weatherResult.cloudCoverage = skyCoverEntry.getValue() as? Int
//                    
//                    if (weatherResult.cloudCoverage < 20) {
//                        weatherResult.forecast = "Sunny" //0-19% cloud cover is considered Sunny
//                    } else if (weatherResult.cloudCoverage < 60) {
//                        weatherResult.forecast = "Partly Cloudy" //20-59% cloud cover is considered Partly Cloudy
//                    } else if (weatherResult.cloudCoverage < 90) {
//                        weatherResult.forecast = "Mostly Cloudy" //60-89% cloud cover is considered Mostly Cloudy
//                    } else {
//                        weatherResult.forecast = "Overcast" //90-100% cloud cover is considered Overcast
//                    }
//                    
//                    //MARK: Rain
//                    guard let rainEntry = try self.extractFromJSON(jsonPropertiesObj: properties, propertyToExtract: "probabilityOfPrecipitation", uom: "wmoUnit:percent") else {
//                        return error_units
//                    }
//                    self.debugTimeStr(rainEntry)
//                    weatherResult.rainChance = rainEntry.getValue() as? Int
//                    
//                } catch let error {
//                    return error
//                }
//                
//                completionHandler(weatherResult, nil)
//                return nil
//            }, errorHandler: completionHandler)
//            return nil
//        }, errorHandler: completionHandler)
//    }
//}
