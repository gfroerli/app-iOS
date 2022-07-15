//
//  TemperatureAggregations.swift
//  Gfror.li
//
//  Created by Marc on 25.05.21.
//

import Foundation
import SwiftUI

struct TemperatureAggregation: Identifiable {

    let id: String
    let date: Date
    let min: Double
    let avg: Double
    let max: Double

}
