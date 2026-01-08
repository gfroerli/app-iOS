//
//  LocationValidator.swift
//  GfroerliBusiness
//
//  Created by Marc on 20.12.2025.
//

import Foundation
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

struct LocationValidator: ValidatorProtocol {
    
    typealias ValidationInput = APILocationProtocol
    typealias ValidationOutput = BusinessLocation
    
    // MARK: - ValidatorProtocol
    
    func validate(_ input: any ValidationInput) -> ValidationOutput? {
        let id = input.id
        
        // We do not allow locations without a proper name
        guard let name = input.name, !name.isEmpty else {
            return nil
        }
        let shortName = (input.shortName ?? String(name.prefix(3))).uppercased()
        
        // We do not allow locations without a proper coordinates
        guard let latitude = input.latitude, let longitude = input.longitude else {
            return nil
        }
        
        // We do not allow locations without a creation date
        guard let creationDate = input.creationDate else {
            return nil
        }
        
        // We do not allow locations without any temperature measurements
        guard let lastTemperature = input.lastTemperature,
              let lastTemperatureDate = input.lastTemperatureDate else {
            return nil
        }
        
        return BusinessLocation(
            id: id,
            name: name,
            shortName: shortName,
            description: input.description,
            latitude: latitude,
            longitude: longitude,
            creationDate: creationDate,
            sponsorID: input.sponsorID,
            lastTemperature: lastTemperature,
            lastTemperatureDate: lastTemperatureDate,
            highestTemperature: input.highestTemperature,
            lowestTemperature: input.lowestTemperature,
            averageTemperature: input.averageTemperature
        )
    }
}
