//
//  LocationDetailDescriptionView.swift
//  gfroerli
//
//  Created by Marc Kramer on 08.08.26.
//

import SwiftUI

struct LocationDetailDescriptionView: View {

    var description: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("location_description_view_title")
                .font(.title3)
                .bold()

            Text(description)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

#Preview {
    LocationDetailDescriptionView(
        description: "A beautiful lake surrounded by mountains, popular for swimming in the summer months."
    )
}
