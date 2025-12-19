//
//  SponsorValidator.swift
//  GfroerliBusiness
//
//  Created by Marc on 29.12.2025.
//

import Foundation
import GfroerliAPIProtocols
import GfroerliBusinessProtocols

struct SponsorValidator: ValidatorProtocol {
    
    typealias ValidationInput = APISponsorProtocol
    typealias ValidationOutput = BusinessSponsor
    
    // MARK: - ValidatorProtocol

    func validate(_ input: any ValidationInput) -> ValidationOutput? {
        let id = input.id

        // We do not allow sponsors without a proper name
        guard let name = input.name, !name.isEmpty else {
            return nil
        }
        
        // We do not allow sponsors without a proper description
        guard let description = input.description, !description.isEmpty else {
            return nil
        }
        
        // We do not allow sponsors without an image URL
        guard let imageURL = input.imageURL else {
            return nil
        }
        
        return BusinessSponsor(
            id: id,
            name: name,
            description: description,
            imageURL: imageURL
        )
    }
}
