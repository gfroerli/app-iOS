//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import GfroerliBackend
import SwiftUI

struct SponsorView: View {
    @ObservedObject var sponsorVM: SponsorViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            if case ViewModelState.failed = sponsorVM.modelState {
                
                VStack {
                    Text("sponsor_view_failed")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.secondary)
                    
                    Button {
                        sponsorVM.loadSponsor()
                    } label: {
                        Text("Retry")
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
                
                AsyncImage(url: sponsorVM.sponsor?.logoURL) { image in
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
                    Text(sponsorVM.sponsor?.description ?? "sponsor_view_no_descriptionn")
                }
                .redacted(reason: sponsorVM.modelState == .loading ? .placeholder : [])
            }
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

// MARK: - Preview

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView(sponsorVM: SponsorViewModel(id: 1))
    }
}
