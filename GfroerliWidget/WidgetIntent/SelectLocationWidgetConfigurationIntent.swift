//
//  AppIntent.swift
//  GfroerliWidget
//
//  Created by Marc on 17.05.2024.
//

import AppIntents
import WidgetKit

struct SelectLocationWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "intent_title_select_location"
    static var description = IntentDescription("intent_description_select_location")

    // An example configurable parameter.
    @Parameter(title: "location")
    var location: LocationAppEntity
    
    init() { }
    
    static var previewIntent: SelectLocationWidgetConfigurationIntent {
        let intent = SelectLocationWidgetConfigurationIntent()
        intent.location = LocationAppEntity.example
        return intent
    }
}
