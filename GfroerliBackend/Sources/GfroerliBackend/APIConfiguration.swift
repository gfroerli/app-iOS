//
//  APIConfiguration.swift
//
//
//  Created by Marc Kramer on 12.06.22.
//

import Foundation

/// Contains predefined parameters used during the fetching process
public enum APIConfiguration {
    // MARK: Date handling

    static var formatter = DateFormatter()
    static let dateFormat = "yyyy-MM-dd"

    /// Removes given days from date and formats it to the `dateFormat` style
    /// - Parameters:
    ///   - subtractingDays: Number of days to subtract
    ///   - date: Date
    /// - Returns: String in `dateFormat` style
    public static func preprocessDate(subtractingDays: Int = 0, from date: Date) -> String {
        guard let offsetDate = Calendar.current.date(byAdding: .day, value: -subtractingDays, to: date) else {
            return ""
        }

        formatter.dateFormat = dateFormat
        return formatter.string(from: offsetDate)
    }
}
