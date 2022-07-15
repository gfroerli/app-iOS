// swiftlint:disable identifier_name
import Foundation
import CoreLocation

struct Sensor: Codable, Identifiable, Equatable {
    init(id: Int,
         device_name: String?,
         caption: String?,
         latitude: Double?,
         longitude: Double?,
         sponsor_id: Int?,
         createdAt: Date?,
         latestTemp: Double?,
         maxTemp: Double?,
         minTemp: Double?,
         avgTemp: Double?,
         lastTempTime: Date?) {

            self.id = id
            self.device_name = device_name
            self.caption = caption
            self.latitude = latitude
            self.longitude = longitude
            self.sponsor_id = sponsor_id
            self.createdAt = createdAt
            self.latestTemp = latestTemp
            self.maxTemp = maxTemp
            self.minTemp = minTemp
            self.avgTemp = avgTemp
            self.lastTempTime = lastTempTime
    }
    
    let id: Int
    let device_name: String?
    let caption: String?
    let latitude: Double?
    let longitude: Double?
    let sponsor_id: Int?
    let createdAt: Date?
    let latestTemp: Double?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?
    let lastTempTime: Date?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case device_name = "device_name"
        case caption = "caption"
        case latitude = "latitude"
        case longitude = "longitude"
        case sponsor_id = "sponsor_id"
        case createdAt = "created_at"
        case latestTemp = "latest_temperature"
        case maxTemp = "maximum_temperature"
        case minTemp = "minimum_temperature"
        case avgTemp = "average_temperature"
        case lastTempTime = "latest_measurement_at"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        device_name = try values.decodeIfPresent(String.self, forKey: .device_name)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        sponsor_id = try values.decodeIfPresent(Int.self, forKey: .sponsor_id)
        latestTemp = try values.decodeIfPresent(Double.self, forKey: .latestTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)
        let createdUNIXStamp = try values.decodeIfPresent(Double.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: createdUNIXStamp ?? 0.0)
        let lastMeasurementUNIXStamp = try values.decodeIfPresent(Double.self, forKey: .lastTempTime)
        lastTempTime = Date(timeIntervalSince1970: (lastMeasurementUNIXStamp ?? 0.0))
    }
}

extension Sensor {
    
    var sensorName: String {
        device_name ?? "No name"
    }
    
    var sensorCaption: String {
        caption ?? "No Caption"
    }
    
    var coordinates: CLLocationCoordinate2D {
        guard let lat = latitude,
              let lon = longitude else {
                  return CLLocationCoordinate2DMake(0.0, 0.0)
              }
        return CLLocationCoordinate2DMake(lat, lon)
    }
}

let testSensor2 = Sensor(
    id: 2,
    device_name: "testSensor2",
    caption: "caption2",
    latitude: 47.28073,
    longitude: 8.72869,
    sponsor_id: 0,
    createdAt: Date(),
    latestTemp: 20.0,
    maxTemp: 20.0,
    minTemp: 0.0,
    avgTemp: 10.0,
    lastTempTime: Date()
)

let testSensor1 = Sensor(
    id: 10,
    device_name:
        "HSR Badewiese",
    caption: "caption1",
    latitude: 47.28073,
    longitude: 8.72869,
    sponsor_id: 0,
    createdAt: Date(),
    latestTemp: 20.0,
    maxTemp: 20.0,
    minTemp: 0.0,
    avgTemp: 10.0,
    lastTempTime: Date().addingTimeInterval(2000000)
)
