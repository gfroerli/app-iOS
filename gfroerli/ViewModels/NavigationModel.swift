//
//  NavigationModel.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import Combine
import Foundation
import GfroerliBackend
import SwiftUI

class NavigationModel: ObservableObject {
    @Published var navigationPath: [Location] = []
}
