//
//  SponsorView.swift
//  gfroerli
//
//  Created by Marc on 03.09.22.
//

import SwiftUI
import GfroerliAPI

struct SponsorView: View {
    @Binding var sponsor: Sponsor?
        
    // MARK: - Body
    var body: some View {
        
        VStack(alignment: .leading) {
            
                VStack(alignment: .leading) {
                    Text("Sponsored by:")
                        .font(.title)
                    Text(sponsor!.name)
                        .font(.largeTitle)
                }
                .bold()
                .redacted(reason: sponsor == nil ? .placeholder : [])
                
                AsyncImage(url: sponsor!.logoUrl) { image in
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
                
                VStack{
                    Text(sponsor!.description)
                }
        }
        .padding()
        .defaultBoxStyle()
    }
}

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView(sponsor: .constant(Sponsor.exampleSponsor()))
    }
}
