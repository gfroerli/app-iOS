//
//  UIDevice.swift
//  gfroerli
//
//  Created by Marc Kramer on 14.06.22.
//

import Foundation
import UIKit

extension UIDevice {
    static var idiom: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }

    static var isIPad: Bool {
        idiom == .pad
    }

    static var isiPhone: Bool {
        idiom == .phone
    }
}
