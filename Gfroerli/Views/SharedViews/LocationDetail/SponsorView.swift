//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import GfroerliBackend
import SwiftUI

struct SponsorView: View {
    typealias Config = AppConfiguration.MapPreviewView

    var sponsorVM: SponsorViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            if sponsorVM.sponsor == nil {
                VStack {
                    Text("sponsor_view_failed")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.secondary)

                    Button {
                        Task {
                            await sponsorVM.loadSponsor()
                        }
                    } label: {
                        Text("sponsor_view_retry")
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
            }
            else {
                VStack(alignment: .leading) {
                    Text("sponsor_view_title")
                        .font(.title2)

                    Text(sponsorVM.sponsor?.name ?? "sponsor_view_no_name")
                        .font(.title2)
                        .redacted(
                            reason: sponsorVM.sponsor == nil ? .placeholder : []
                        )
                }
                .bold()

                if horizontalSizeClass == .compact {
                    sponsorContentView()
                }
                else {
                    HStack(alignment: .top) {
                        sponsorContentView()
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .frame(idealHeight: Config.mapHeight)
        .defaultBoxStyle()
    }
    
    @MainActor
    @ViewBuilder
    func sponsorContentView() -> some View {
        AsyncImage(url: sponsorVM.sponsor?.imageURL) { image in
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
            Text(sponsorVM.sponsor?.desc ?? "sponsor_view_no_descriptionn")
        }
        .redacted(reason: sponsorVM.sponsor == nil ? .placeholder : [])
    }
}

// MARK: - Preview

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView(sponsorVM: SponsorViewModel(id: 1))
    }
}
