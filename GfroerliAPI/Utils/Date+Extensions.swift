//
//  Date+Extensions.swift
//  GfroerliAPI
//
//  Created by Marc on 11.09.22.
//

import Foundation

extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
}
