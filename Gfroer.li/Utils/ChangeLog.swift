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
                Image(systemName: "star.filll")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow)
            case .bugfix:
                Image(systemName: "bolt.slash.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, .yellow)
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
    let version: String
    let items: [ChangeItem]
    
    enum CodingKeys: CodingKey {
        case version
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let versionDouble = try container.decode(Double.self, forKey: .version)
        let localizedString = NSLocalizedString("changelog_view_version_header", comment: "")
        self.version = localizedString + " \(versionDouble)"
        self.items = try container.decode([ChangeItem].self, forKey: .items)
    }
}

struct ChangeLog: Codable {
    static let log = Bundle.main.decode([ChangeItems].self, from: "ChangeLog.json")
}
