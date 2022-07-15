//
//  ChangeNote.swift
//  Gfror.li
//
//  Created by Marc on 23.03.21.
//

import Foundation

struct ChangeNote: Decodable, Identifiable {

    var id: String {UUID().uuidString}
    let version: String
    let changes: [String]
    let fixes: [String]

    static let allChangeNotes = Bundle.main.decode([ChangeNote].self, from: "Changes.json")
}

struct WhatsNew: Decodable, Identifiable {

    var id: String {UUID().uuidString}
    let imageName: String
    let title: String
    let text: String

    static let whatsNewNotes = Bundle.main.decode([WhatsNew].self, from: "WhatsNew.json")
}
