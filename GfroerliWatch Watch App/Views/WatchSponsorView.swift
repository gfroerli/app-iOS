//
//  WatchSponsorView.swift
//  GfroerliWatch Watch App
//
//  Created by Marc on 30.05.2024.
//

import GfroerliBackend
import SwiftUI

struct WatchSponsorView: View {
    
    var sponsorVM: SponsorViewModel

    var body: some View {
        
        ScrollView {
            VStack {
                AsyncImage(url: sponsorVM.sponsor?.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        
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
                    
                Text(sponsorVM.sponsor?.desc ?? "sponsor_view_no_description")
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .background(Material.thin, in: RoundedRectangle(cornerRadius: 7))
            .padding(.horizontal, 5)
        }
        .navigationTitle("sponsor_view_title")
    }
}

#Preview {
    NavigationStack {
        WatchLocationDetailTabView(locationID: 7)
    }
}
