// swiftlint:disable identifier_name

import Foundation
import Combine

class SensorViewModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()

    @Published var sensorArray = [Sensor]() { didSet {didChange.send(()) } }
}

struct Sensor: Codable {
	let id: Int?
	let device_name: String?
	let caption: String?
	let latitude: Double?
	let longitude: Double?
	let sponsor_id: Int?
	let measurement_ids: [Int]?
	let created_at: String?
	let updated_at: String?
	let last_measurement: Measurement?
	let url: String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case device_name = "device_name"
		case caption = "caption"
		case latitude = "latitude"
		case longitude = "longitude"
		case sponsor_id = "sponsor_id"
		case measurement_ids = "measurement_ids"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case last_measurement = "last_measurement"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		device_name = try values.decodeIfPresent(String.self, forKey: .device_name)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
		sponsor_id = try values.decodeIfPresent(Int.self, forKey: .sponsor_id)
		measurement_ids = try values.decodeIfPresent([Int].self, forKey: .measurement_ids)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		last_measurement = try values.decodeIfPresent(Measurement.self, forKey: .last_measurement)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}

struct Sensors: Codable {
    let sensors: [Sensor]?

    enum CodingKeys: String, CodingKey {
        case sensors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sensors = try container.decode([Sensor].self, forKey: .sensors)
    }
}
