//
//  DefaultsCoordinator.swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import Foundation

@MainActor
final class DefaultsCoordinator: Sendable {
    static let shared = DefaultsCoordinator()

    private let defaults = UserDefaults.standard

    // MARK: - Lifecycle

    init() { }

    // MARK: - Keys

    private enum Keys {
        case latestVersion
        case favoriteCount
        case usageDaysCount
        case lastUsageDay
        case reviewRequestedVersion
        case successfulDetailViewsCount

        // Key
        func key() -> String {
            switch self {
            case .latestVersion:
                "latestVersion"
            case .favoriteCount:
                "favoriteCount"
            case .usageDaysCount:
                "usageDaysCount"
            case .lastUsageDay:
                "lastUsageDay"
            case .reviewRequestedVersion:
                "reviewRequestedVersion"
            case .successfulDetailViewsCount:
                "successfulDetailViewsCount"
            }
        }
    }

    // MARK: - Public functions

    /// Checks if last opened version was lower and if the new features overview should be shown
    /// - Returns: Bool if new features overview should be shown
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

    /// Records that the app was used today, incrementing the distinct-usage-day counter once per calendar day.
    /// Used as a gating signal so review prompts only reach users who return across multiple days.
    public func registerAppUsage() {
        let today = Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceReferenceDate)
        guard defaults.integer(forKey: Keys.lastUsageDay.key()) != today else {
            return
        }
        defaults.set(today, forKey: Keys.lastUsageDay.key())
        defaults.set(usageDaysCount() + 1, forKey: Keys.usageDaysCount.key())
    }

    /// Records that the user marked a location as a favorite and decides whether this is a good moment to
    /// ask for an App Store review.
    ///
    /// A review is only requested once per app version, and only for engaged users (at least two favorites and
    /// app usage on at least two distinct days). The system additionally throttles how often the prompt is shown.
    /// - Returns: `true` if the caller should present the review request.
    public func shouldRequestReviewAfterFavorite() -> Bool {
        let favoriteCount = self.favoriteCount() + 1
        defaults.set(favoriteCount, forKey: Keys.favoriteCount.key())

        guard canRequestReviewForCurrentVersion() else {
            return false
        }

        guard favoriteCount >= 2, usageDaysCount() >= 2 else {
            return false
        }

        return markReviewRequestedForCurrentVersion()
    }

    /// Records a successful location detail view and decides whether this is a good moment to ask for a review.
    ///
    /// Acts as a fallback for engaged users who browse temperatures but never favorite a location: a review is
    /// requested after several successful detail views spread across multiple days, at most once per app version.
    /// - Returns: `true` if the caller should present the review request.
    public func shouldRequestReviewAfterDetailView() -> Bool {
        let viewCount = successfulDetailViewsCount() + 1
        defaults.set(viewCount, forKey: Keys.successfulDetailViewsCount.key())

        guard canRequestReviewForCurrentVersion() else {
            return false
        }

        guard viewCount >= 5, usageDaysCount() >= 3 else {
            return false
        }

        return markReviewRequestedForCurrentVersion()
    }

    // MARK: - Private Functions

    private func favoriteCount() -> Int {
        defaults.integer(forKey: Keys.favoriteCount.key())
    }

    private func usageDaysCount() -> Int {
        defaults.integer(forKey: Keys.usageDaysCount.key())
    }

    private func successfulDetailViewsCount() -> Int {
        defaults.integer(forKey: Keys.successfulDetailViewsCount.key())
    }

    /// Whether the current app version hasn't already been used to request a review.
    private func canRequestReviewForCurrentVersion() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        return defaults.string(forKey: Keys.reviewRequestedVersion.key()) != currentVersion
    }

    /// Stamps the current app version as having requested a review so we only ask once per release.
    /// - Returns: `true` on success, `false` if the current version couldn't be determined.
    private func markReviewRequestedForCurrentVersion() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        defaults.set(currentVersion, forKey: Keys.reviewRequestedVersion.key())
        return true
    }

    private func latestVersion() -> String {
        guard let value = defaults.value(forKey: Keys.latestVersion.key()) as? String else {
            defaults.set("0.0", forKey: Keys.latestVersion.key())
            return "0.0"
        }
        return value
    }
}
