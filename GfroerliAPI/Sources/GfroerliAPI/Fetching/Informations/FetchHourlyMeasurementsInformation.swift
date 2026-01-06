//
//  FetchHourlyMeasurementsInformation.swift
//  GfroerliAPI
//
//  Created by Marc on 18.12.2025.
//

import Foundation
import GfroerliAPIProtocols

struct FetchHourlyMeasurementsInformation: FetchInformationProtocol {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let locationID: Int
    private let startDate: Date
    private let endDate: Date

    // MARK: - Lifecycle
    
    init(locationID: Int, startDate: Date, endDate: Date) {
        self.locationID = locationID
        self.startDate = startDate
        self.endDate = endDate
    }
    
    // MARK: - FetchInformationProtocol
    
    func createRequest(token: String) -> URLRequest {
        // Create request from type
        var request = URLRequest(url: assembleURL())
        
        // Set token and method
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Return request
        return request
    }
    
    func assembleURL() -> URL {
        let startDateString = FetchHourlyMeasurementsInformation.dateFormatter.string(from: startDate)
        let endDateString = FetchHourlyMeasurementsInformation.dateFormatter.string(from: endDate)
       
        let url = baseURL
            .absoluteString +
            "/sensors/\(locationID)/hourly_temperatures?from=\(startDateString)&to=\(endDateString)&limit=100"
        return URL(string: url)!
    }
}
