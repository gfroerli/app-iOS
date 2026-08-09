//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import GfroerliBusinessMocks
import GfroerliBusinessProtocols
import SwiftUI

struct SponsorView: View {
    typealias Config = AppConfiguration.MapPreviewView

    var sponsor: BusinessSponsorProtocol

    /// Compact vertical height means a landscape phone layout, where we cap the logo width.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text("sponsor_view_title")
                .font(.title3)
                .bold()

            sponsorImageView()
                .frame(maxWidth: verticalSizeClass == .compact ? 250 : .infinity)

            Text(sponsor.name)
                .font(.title3)
                .bold()

            Text(sponsor.description)
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }

    @MainActor
    @ViewBuilder
    func sponsorImageView() -> some View {
        AsyncImage(url: sponsor.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .background(.white)
                .cornerRadius(AppConfiguration.General.cornerRadius)

        } placeholder: {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SponsorView(sponsor: BusinessSponsorMock.exampleSponsor1)
}
