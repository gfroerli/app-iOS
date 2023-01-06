//
//  ChangeLog.swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import Foundation
import SwiftUI

struct ChangeItem: Identifiable, Decodable {
    
    let id = UUID()
    let description: String
    let changeType: ChangeType
    
    enum ChangeType: String, Decodable {
        case feature, improvement, bugfix
        
        @ViewBuilder
        public func image() -> some View {
            switch self {
            case .feature:
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
            case .improvement:
                Image(systemName: "thermometer.sun")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .yellow, Color.accentColor)
            case .bugfix:
                Image(systemName: "thermometer.snowflake")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, Color.accentColor, Color.accentColor)
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case description
        case changeType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
        self.changeType = try container.decode(ChangeType.self, forKey: .changeType)
    }
}

struct ChangeItems: Identifiable, Decodable {
    
    let id = UUID()
    let version: Double
    let items: [ChangeItem]
    
    enum CodingKeys: CodingKey {
        case version
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(Double.self, forKey: .version)
        self.items = try container.decode([ChangeItem].self, forKey: .items)
    }
}

struct ChangeLog: Codable {
    static let log = Bundle.main.decode([ChangeItems].self, from: "ChangeLog.json")
}
