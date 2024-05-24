//
//  NewFeatures.swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import Foundation

struct Feature: Identifiable, Codable {
    let id = UUID()
    let imageName: String
    let title: String
    let text: String

    enum CodingKeys: CodingKey {
        case imageName
        case title
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
    }
}

struct NewFeatures: Codable {
    static let latestFeatures = Bundle.main.decode([Feature].self, from: "NewFeatures.json")
}
