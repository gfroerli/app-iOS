//
//  GfroerliWidgetBundle.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import GfroerliBackend
import SwiftUI
import WidgetKit

@main
struct GfroerliWidgetBundle: WidgetBundle {
    var body: some Widget {
        SingleLocationWidget()
        SingleLocationLockScreenWidget()
    }
}
