//
//  AppIntent.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import AppIntents
import WidgetKit

struct SingleLocationWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "intent_title_select_location"
    static var description = IntentDescription("intent_description_select_location")

    // An example configurable parameter.
    @Parameter(title: "location")
    var location: LocationAppEntity?
    
    init() { }
    
    static var previewIntent: SingleLocationWidgetConfigurationIntent {
        let intent = SingleLocationWidgetConfigurationIntent()
        intent.location = LocationAppEntity.example
        return intent
    }
}
