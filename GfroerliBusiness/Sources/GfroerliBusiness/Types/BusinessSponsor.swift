//
//  BusinessSponsor.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliBusinessProtocols

struct BusinessSponsor: BusinessSponsorProtocol {
    
    // MARK: - Properties
    
    var id: Int
    var name: String
    var description: String
    var imageURL: URL
}
