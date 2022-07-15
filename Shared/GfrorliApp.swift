//
//  Gfro_r_liApp.swift
//  Shared
//
//  Created by Niklas Liechti on 24.06.20.
//

import SwiftUI
import Foundation

@main
struct GfrorliApp: App {

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            IOSMainView()
            #endif
        }
    }
}

struct GfrorliApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
