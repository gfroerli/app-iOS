//
//  InlineLocationView.swift
//  gfroerli
//
//  Created by Marc on 15.10.22.
//

import GfroerliAPI
import SwiftUI

struct InlineLocationView: View {
    
    let location: Location
    
    @AppStorage("favorites") private var favorites = [Int]()
    @State var isFavorite = false
    
    var body: some View {
        
        HStack {
            Text(location.name)
                .bold()
            if isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.small)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(location.latestTemperatureString)
                Text(location.lastTemperatureDateString)
            }
            .font(.callout)
            .foregroundColor(.secondary)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .padding(.leading, 3)
        }
        .contentShape(Rectangle())
        .padding(2)
        
        .onAppear {
            isFavorite = favorites.contains(location.id)
        }
    }
}

struct InlineLocationView_Previews: PreviewProvider {
    static var previews: some View {
        InlineLocationView(location: Location.exampleLocation())
    }
}
