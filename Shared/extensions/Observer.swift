//
//  Observer.swift
//  iOS
//
//  Created by Marc on 04.05.21.
//

import Foundation
import UIKit
import SwiftUI

class Observer: ObservableObject {
    
    @Published var enteredForeground = true
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIScene.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }
}
