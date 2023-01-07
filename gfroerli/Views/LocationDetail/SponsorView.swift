//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import GfroerliAPI
import SwiftUI

struct SponsorView: View {
    @ObservedObject var sponsorVM: SponsorViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            if case ViewModelState.failed = sponsorVM.modelState {
                
                VStack {
                    Text("Fetching Sponsor Failed")
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
                    Text("Sponsored by:")
                        .font(.title2)
                    
                    Text(sponsorVM.sponsor?.name ?? "No Name")
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
                    Text(sponsorVM.sponsor?.description ?? "No Description")
                }
                .redacted(reason: sponsorVM.modelState == .loading ? .placeholder : [])
            }
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView(sponsorVM: SponsorViewModel(id: 1))
    }
}
