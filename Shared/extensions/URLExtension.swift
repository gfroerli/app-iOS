//
//  URLExtension.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import Foundation

extension URL {
  var isDeeplink: Bool {
    return scheme == "ch.coredump.gfroerli" // matches my-url-scheme://<rest-of-the-url>
  }

  var tabIdentifier: String? {
    guard isDeeplink else { return nil }

    switch host {
    case "home": return "Overview"
    case "overview": return "Overview"
    case "favorites": return "Favorites"
    case "settings": return "Settings"
    default: return nil
    }
  }
}
