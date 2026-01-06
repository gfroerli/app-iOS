//
//  BusinessLocation.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation
import GfroerliBusinessProtocols

struct BusinessLocation: BusinessLocationProtocol {
   
    // MARK: - Properties

    let id: Int
    let name: String
    let shortName: String
    let description: String?
    let latitude: Double
    let longitude: Double
    let creationDate: Date
    
    let sponsorID: Int?
    
    let lastTemperature: Double
    let lastTemperatureDate: Date
    
    let highestTemperature: Double?
    let lowestTemperature: Double?
    let averageTemperature: Double?
    
    var isActive: Bool {
        let current = Date.now
        let thresholdDate = Calendar.current.date(byAdding: .hour, value: -72, to: current)!
        return lastTemperatureDate >= thresholdDate
    }
    
    var lastTemperatureString: String {
        MeasurementHelper.shared.format(lastTemperature)
    }
    
    var lastTemperatureDateString: String {
        MeasurementHelper.shared.relativeDateString(from: lastTemperatureDate)
    }
    
    var highestTemperatureString: String {
        guard let highestTemperature else {
            return "-"
        }
        return MeasurementHelper.shared.format(highestTemperature)
    }
    
    var lowestTemperatureString: String {
        guard let lowestTemperature else {
            return "-"
        }
        return MeasurementHelper.shared.format(lowestTemperature)
    }
    
    var averageTemperatureString: String {
        guard let averageTemperature else {
            return "-"
        }
        return MeasurementHelper.shared.format(averageTemperature)
    }
}
