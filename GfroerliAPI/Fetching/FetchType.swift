//
//  FetchType.swift
//  
//
//  Created by Marc Kramer on 12.06.22.
//

import Foundation

/// Defines common API Calls to the Gfrör.li server
public enum FetchType {
    
    /// Used for fetching all locations
    case allLocations
    
    /// Used for fetching single location
    /// - Parameter id: Sensor ID as Int
    case singleLocation(id: Int)
    
    /// Used for fetching single sponsor
    /// - Parameter id: Sponsor ID as Int
    case sponsor(id: Int)
    
    /// Used for fetching date interval of hourly temperatures for a sensor
    /// - Parameter sensorID: Int of location ID
    /// - Parameter from: Date of beginning of interval
    /// - Parameter to: Date of end of interval
    case hourlyTemperatures(locationID: Int, from: Date, to: Date)
    
    /// Used for fetching date interval of daily temperatures for a location
    /// - Parameter sensorID: Int of location ID
    /// - Parameter from: Date of beginning of interval
    /// - Parameter to: Date of end of interval
    case dailyTemperatures(locationID: Int, from: Date, to: Date)
    
    
    /// The assembled URL for the given case
    public var assembledURL: URL {
        switch self {
            
        case .allLocations:
            return Foundation.URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors")!
            
        case .singleLocation(id: let id):
            return Foundation.URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)")!
            
        case .sponsor(id: let id):
            return Foundation.URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)/sponsor")!
            
        case .hourlyTemperatures(locationID: let locationID, from: let startDate, to: let endDate):
            
            // Due to the sensors not being in GMT, We also must fetch the day before to be able to show all the hourly values in a given day. Therefore we substrac one day from startDate.
            let startDateString = Configuration.preprocessDate(subtractingDays: 1, from: startDate)
            let endDateString = Configuration.preprocessDate(subtractingDays: 0, from: endDate)
            
            return Foundation.URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/hourly_temperatures?from=\(startDateString)&to=\(endDateString)&limit=100")!
            
        case .dailyTemperatures(locationID: let locationID, from: let startDate, to: let endDate):
            let startDateString = Configuration.preprocessDate(subtractingDays: 0, from: startDate)
            let endDateString = Configuration.preprocessDate(subtractingDays: 0, from: endDate)
            
            return Foundation.URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(locationID)/daily_temperatures?from=\(startDateString)&to=\(endDateString)&limit=100")!
        }
    }
}
