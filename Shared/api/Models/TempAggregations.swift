// swiftlint:disable identifier_name

import Foundation
import Combine

struct HourlyAggregation: Codable, Identifiable, Aggregation {

    internal init(id: String?, date: String?, hour: Int?, maxTemp: Double?, minTemp: Double?, avgTemp: Double?) {
        self.id = id
        self.date = date
        self.hour = hour
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
    }

    let id: String?
    let date: String?
    let hour: Int?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?

    enum CodingKeys: String, CodingKey {

        case date = "aggregation_date"
        case hour = "aggregation_hour"
        case minTemp = "minimum_temperature"
        case maxTemp = "maximum_temperature"
        case avgTemp = "average_temperature"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        date = try values.decodeIfPresent(String.self, forKey: .date)
        hour = try values.decodeIfPresent(Int.self, forKey: .hour)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)
    }

    static var hourlyExampleData = [

        HourlyAggregation(id: "0", date: "00", hour: 0, maxTemp: 22.5, minTemp: 22.3, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 1, maxTemp: 22.8, minTemp: 22.5, avgTemp: 22.7),
        HourlyAggregation(id: "0", date: "00", hour: 2, maxTemp: 22.9, minTemp: 22.8, avgTemp: 22.8),
        HourlyAggregation(id: "0", date: "00", hour: 3, maxTemp: 22.7, minTemp: 22.3, avgTemp: 22.6),
        HourlyAggregation(id: "0", date: "00", hour: 4, maxTemp: 22.5, minTemp: 22.0, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 5, maxTemp: 22.0, minTemp: 21.6, avgTemp: 21.8),
        HourlyAggregation(id: "0", date: "00", hour: 6, maxTemp: 22.0, minTemp: 21.6, avgTemp: 21.8),
        HourlyAggregation(id: "0", date: "00", hour: 7, maxTemp: 22.4, minTemp: 22.0, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 8, maxTemp: 22.8, minTemp: 22.3, avgTemp: 22.6),
        HourlyAggregation(id: "0", date: "00", hour: 9, maxTemp: 23.4, minTemp: 23.0, avgTemp: 23.2),
        HourlyAggregation(id: "0", date: "00", hour: 10, maxTemp: 23.6, minTemp: 23.3, avgTemp: 23.5),
        HourlyAggregation(id: "0", date: "00", hour: 11, maxTemp: 23.8, minTemp: 23.2, avgTemp: 23.8),
        HourlyAggregation(id: "0", date: "00", hour: 12, maxTemp: 24.0, minTemp: 23.3, avgTemp: 24.0),
        HourlyAggregation(id: "0", date: "00", hour: 13, maxTemp: 24.4, minTemp: 23.3, avgTemp: 24.1),
        HourlyAggregation(id: "0", date: "00", hour: 14, maxTemp: 24.0, minTemp: 23.2, avgTemp: 24.0),
        HourlyAggregation(id: "0", date: "00", hour: 15, maxTemp: 23.8, minTemp: 23.2, avgTemp: 23.8),
        HourlyAggregation(id: "0", date: "00", hour: 16, maxTemp: 23.7, minTemp: 23.3, avgTemp: 23.6),
        HourlyAggregation(id: "0", date: "00", hour: 17, maxTemp: 23.5, minTemp: 23.5, avgTemp: 23.4),
        HourlyAggregation(id: "0", date: "00", hour: 18, maxTemp: 23.4, minTemp: 23.4, avgTemp: 23.3),
        HourlyAggregation(id: "0", date: "00", hour: 19, maxTemp: 23.1, minTemp: 23.2, avgTemp: 22.8),
        HourlyAggregation(id: "0", date: "00", hour: 21, maxTemp: 22.9, minTemp: 22.6, avgTemp: 22.6),
        HourlyAggregation(id: "0", date: "00", hour: 22, maxTemp: 22.9, minTemp: 22.6, avgTemp: 22.5),
        HourlyAggregation(id: "0", date: "00", hour: 23, maxTemp: 22.5, minTemp: 22.3, avgTemp: 22.4),
        HourlyAggregation(id: "0", date: "00", hour: 24, maxTemp: 22.2, minTemp: 22.0, avgTemp: 22.1)
    ]

}

struct DailyAggregation: Codable, Identifiable, Aggregation {

    internal init(id: String?, date: String?, maxTemp: Double?, minTemp: Double?, avgTemp: Double?) {
        self.id = id
        self.date = date
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
    }

    let id: String?
    let date: String?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?

    enum CodingKeys: String, CodingKey {
        case date = "aggregation_date"
        case minTemp = "minimum_temperature"
        case maxTemp = "maximum_temperature"
        case avgTemp = "average_temperature"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        date = try values.decodeIfPresent(String.self, forKey: .date)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)

    }
    static var weekExample = [
        DailyAggregation(id: "0", date: "2020-08-01", maxTemp: 24.3, minTemp: 20.0, avgTemp: 20.2),
        DailyAggregation(id: "0", date: "2020-08-02", maxTemp: 24.3, minTemp: 20.0, avgTemp: 21.2),
        DailyAggregation(id: "0", date: "2020-08-03", maxTemp: 24.3, minTemp: 20.0, avgTemp: 22.2),
        DailyAggregation(id: "0", date: "2020-08-04", maxTemp: 24.3, minTemp: 20.0, avgTemp: 24.2),
        DailyAggregation(id: "0", date: "2020-08-05", maxTemp: 24.3, minTemp: 20.0, avgTemp: 23.2)
    ]

}

protocol Aggregation {
    var id: String? {get}
    var date: String? {get}
    var minTemp: Double? {get}
    var maxTemp: Double? {get}
    var avgTemp: Double? {get}
}
