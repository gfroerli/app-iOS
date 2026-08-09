//
//  LocationDetailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 24.06.22.
//

import GfroerliBusinessMocks
import Observation
import StoreKit
import SwiftUI

@MainActor
struct LocationDetailView: View {
    @AppStorage("favorites") private var favorites = [Int]()

    @Environment(\.requestReview) private var requestReview

    @State private var viewModel: LocationDetailViewModel

    @State private var isFavorite = false

    // Ensures a single detail view instance only counts once towards the review-request gate.
    @State private var hasCountedForReview = false

    // MARK: - Lifecycle

    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if let location = viewModel.location {
                    HStack(spacing: 12) {
                        LocationDetailLastTemperatureView(location: location)
                            .frame(maxWidth: .infinity)
                        LocationDetailTemperatureSummaryView(location: location)
                            .frame(maxWidth: .infinity)
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    if let description = location.description,
                       !description.isEmpty {
                        LocationDetailDescriptionView(description: description)
                    }

                    LocationTemperatureHistoryView(locationID: viewModel.locationID)
                    
                    if let sponsor = viewModel.sponsor {
                        SponsorView(sponsor: sponsor)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.location?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            Button {
                isFavorite ? removeFavorite() : markAsFavorite()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isFavorite ? .yellow : .accentColor)
                    .imageScale(.large)
            }
        }
        .refreshable {
            try? await viewModel.loadLocation()
        }
        .onAppear {
            Task {
                try? await viewModel.loadLocation()
                registerSuccessfulViewIfNeeded()
            }
            isFavorite = favorites.contains(viewModel.locationID)
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            Task {
                try? await viewModel.loadLocation()
            }
        }
    }

    // MARK: - Private Functions

    @MainActor private func markAsFavorite() {
        favorites.append(viewModel.locationID)
        isFavorite = true

        // Favoriting is a strong positive-intent signal, making it a good moment to ask for a review.
        if DefaultsCoordinator.shared.shouldRequestReviewAfterFavorite() {
            requestReview()
        }
    }

    /// Counts a successful detail view (content actually loaded) once per view instance, and requests a review
    /// if the user has reached the browsing milestone. Fallback for users who never favorite a location.
    @MainActor private func registerSuccessfulViewIfNeeded() {
        guard !hasCountedForReview, viewModel.location != nil else {
            return
        }
        hasCountedForReview = true

        if DefaultsCoordinator.shared.shouldRequestReviewAfterDetailView() {
            requestReview()
        }
    }

    @MainActor private func removeFavorite() {
        guard let index = favorites.firstIndex(of: viewModel.locationID)
        else {
            return
        }
        favorites.remove(at: index)
        isFavorite = false
    }
}

#Preview {
    @Previewable @State var viewModel = LocationDetailViewModel(
        locationID: 0,
        locationManager: BusinessLocationManagerMock(),
        sponsorManager: BusinessSponsorManagerMock()
    )
    
    NavigationStack {
        LocationDetailView(
            viewModel: viewModel
        )
    }
}
