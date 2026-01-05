//
//  BusinessSponsorMock.swift
//  GfroerliBusiness
//
//  Created by Marc on 05.01.2026.
//

import Foundation
import GfroerliBusinessProtocols

public struct BusinessSponsorMock: BusinessSponsorProtocol, Sendable {
    
    // MARK: - BusinessSponsorProtocol
    
    public var id: Int
    
    public var name: String
    
    public var description: String
    
    public var imageURL: URL
    
    // MARK: - Example Sponsors
    
    public static let exampleSponsor1 = BusinessSponsorMock(
        id: 0,
        name: "Example Sponsor 1",
        description: "This is a simple test sponsor.",
        imageURL: URL(string: "https://files.coredump.ch/partnerlogos/eidgenossenschaft.png")!
    )
}
