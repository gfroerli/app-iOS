//
//  DefaultsCoordinator.swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import Foundation

class DefaultsCoordinator {
    static let shared = DefaultsCoordinator()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    
    init() { }
    
    // MARK: - Keys
    
    private enum Keys {
        case latestVersion
        
        // Key
        func key() -> String {
            switch self {
            case .latestVersion:
                return "latestVersion"
            }
        }
    }
    
    // MARK: - Public functions
    
    /// Checks if last opened version was lower and if the new features view should be shown
    /// - Returns: Bool
    public func showNewFeatures() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        guard currentVersion > latestVersion() else {
            return false
        }
        
        defaults.set(currentVersion, forKey: Keys.latestVersion.key())
        defaults.synchronize()
        return true
    }
    
    // MARK: - Private Functions

    private func latestVersion() -> String {
        guard let value = defaults.value(forKey: Keys.latestVersion.key()) as? String else {
            defaults.set("0.0", forKey: Keys.latestVersion.key())
            return "0.0"
        }
        return value
    }
}
