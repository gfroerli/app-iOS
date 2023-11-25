//
//  Configuration.swift
//  gfroerli
//
//  Created by Marc Kramer on 16.06.22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

/// Contains all the configuration values for layout
enum AppConfiguration {
    enum General {
        /// Default corner radius
        static let cornerRadius = 15.0
        /// Default capsule radius
        static let capsuleRadius = 5.0
        /// Default capsule padding
        static let capsulePadding = 4.0
        /// Default horizontal box padding
        static let horizontalBoxPadding = 15.0
        /// Default vertical box padding
        static let verticalBoxPadding = 10.0
    }

    enum LocationDetails {
        /// Height of the top boxes in location details view
        static let topBoxHeight = 180.0
    }

    enum MapPreviewView {
        // Default coordinates to display if coordinate of Location is nil
        static let defaultCoordinates = CLLocation(latitude: 46.80121, longitude: 8.226692)
        // Default region to display if coordinate of Location is nil
        static let defaultRegion = MKCoordinateRegion(
            center: defaultCoordinates.coordinate,
            latitudinalMeters: defaultMapSpan * 5,
            longitudinalMeters: defaultMapSpan * 5
        )
        // Default span of map in meters
        static let defaultMapSpan = 1250.0
        // Height of map
        static let mapHeight = 350.0
    }

    enum MapView {
        // Default coordinates to display if coordinate of Location is nil
        static let defaultCoordinates = CLLocation(latitude: 46.80121, longitude: 8.226692)
        // Default region to display if coordinate of Location is nil
        static let defaultRegion = MKCoordinateRegion(
            center: defaultCoordinates.coordinate,
            latitudinalMeters: defaultMapSpan,
            longitudinalMeters: defaultMapSpan
        )
        // Default span of map in meters
        static let defaultMapSpan = 100_000.0
        // Zoomed in span of map in meters
        static let zoomedMapSpan = 5000.0
        // Font weight of text and images in annotations
        static let fontWeight: Font.Weight = .semibold
    }

    enum Settings {
        /// String containing current version number, e.g. 1.0
        static let lastVersion = " " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        /// URL opening review in appstore
        static let reviewURL: URL = {
            var components = URLComponents(
                url: URL(string: "https://apps.apple.com/us/app/gfr%C3%B6r-li/id1451431723")!,
                resolvingAgainstBaseURL: false
            )

            components?.queryItems = [
                URLQueryItem(name: "action", value: "write-review"),
            ]
            return components!.url!
        }()

        /// URL opening feedback email, containing body
        static let emailURL: URL = {
            let email = "appdev@coredump.ch"
            let subject = "Feedback iOS Version: \(lastVersion)"
            let body = emailBody

            return URL(
                string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"
            )!
        }()

        /// Email body
        private static let emailBody: String = {
            let version =
                "App-Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unkown")"
            let systemVersion = "OS-Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
            let lang = "Language: \(Locale.current.language.languageCode?.identifier ?? "unkown")"
            let str = NSLocalizedString("settings_email_text", comment: "")
            return "</br></br></br></br></br>\(str)</br></br>Info:</br>\(version)</br>\(systemVersion)</br>\(lang)"
        }()

        /// URL to open privacy policy
        static let privacyPolicyURL = URL(string: "https://xn--gfrr-7qa.li/about")!
        /// URL to open gfroerli website
        static let gfroerliURL = URL(string: "https://xn--gfrr-7qa.li")!
        /// URL to open coredump website
        static let coredumpURL = URL(string: "https://www.coredump.ch/")!
        /// URL to open coredump Mastodon
        static let mastodonCoreDumpURL = URL(string: "https://chaos.social/@coredump")!
        /// URL to open GitHub
        static let githubURL = URL(string: "https://github.com/gfroerli")!
    }
}
