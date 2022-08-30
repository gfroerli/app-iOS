//
//  DateUtil.swift
//  gfroerli
//
//  Created by Marc on 30.08.22.
//

import Foundation


class DateUtil {
    /// Returns true if the given date lays in the last 72h
    /// - Parameter givenDate: Date to check
    /// - Returns: Bool if in last 72h
    static func wasInLast72Hours(givenDate: Date) -> Bool {
        let current = Date.now
        let thresholdDate = Calendar.current.date(byAdding: .hour, value: -72, to: current)!
        return givenDate >= thresholdDate
    }
}
