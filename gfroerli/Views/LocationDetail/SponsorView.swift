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
                        .font(.title)
                    
                    Text(sponsorVM.sponsor?.name ?? "No Name")
                        .font(.largeTitle)
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
        .padding()
        .defaultBoxStyle()
    }
}

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView(sponsorVM: SponsorViewModel(id: 1))
    }
}
