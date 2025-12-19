//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import GfroerliBusinessProtocols
import SwiftUI

struct SponsorView: View {
    typealias Config = AppConfiguration.MapPreviewView

    var sponsor: BusinessSponsorProtocol
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("sponsor_view_title")
                Text(sponsor.name)
            }
            .font(.title3)
            .bold()
            
            sponsorContentView()
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
    
    @MainActor
    @ViewBuilder
    func sponsorContentView() -> some View {
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
        
        VStack {
            Text(sponsor.description)
        }
    }
}
