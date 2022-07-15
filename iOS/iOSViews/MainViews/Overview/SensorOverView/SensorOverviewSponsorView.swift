   //
//  SensorOverviewSponsorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//  Refactored by Marc Kramer on 26.06.21
//

import SwiftUI

struct SensorOverviewSponsorView: View {
   
    var sensorID: Int
    
    @StateObject var sponsorVM = SponsorListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Sponsored by:")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
            switch sponsorVM.loadingState {
            case .loaded:
                HStack {
                    Text(sponsorVM.sponsor!.name)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                SponsorImageView(sponsor: sponsorVM.sponsor!)
                 
                Text(sponsorVM.sponsor!.description)
                Spacer()
                
            case .loading:
                LoadingView()
                    .onAppear(perform: {
                        Task { await sponsorVM.load(sponsorId: sensorID)}
                    })
                
            case .failed:
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Loading Sponsor failed. Reason:")
                            .foregroundColor(.secondary)
                        Text(sponsorVM.errorMsg)
                            .foregroundColor(.secondary)
                        Button("Try again") {
                            Task { await sponsorVM.load(sponsorId: sensorID)}
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .multilineTextAlignment(.center)
                
            } // end of switch
        }.padding()
            
    }
}

struct SensorOverviewSponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewSponsorView(sensorID: 1).makePreViewModifier()
    }
}

struct SponsorImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    init(sponsor: Sponsor) {
        imageLoader = ImageLoader(urlString: sponsor.logoUrl)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
    
}
