//
//  Date+Week.swift
//  gfroerli
//
//  Created by Marc on 06.01.23.
//

import Foundation

extension Date {
    var firstDayOfTheSameWeek: Date {
        Calendar.iso8601.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)!
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}
