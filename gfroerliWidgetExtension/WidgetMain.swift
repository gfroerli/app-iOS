//
//  WidgetMain.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct GfroerliWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {

        SingleSensorWidget()

    }
}
