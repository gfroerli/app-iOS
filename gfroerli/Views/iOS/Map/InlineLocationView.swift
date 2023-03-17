//
//  InlineLocationView.swift
//  gfroerli
//
//  Created by Marc on 15.10.22.
//

import GfroerliBackend
import SwiftUI

struct InlineLocationView: View {
    
    let location: Location
    @Environment(\.isSearching) var isSearching

    @AppStorage("favorites") private var favorites = [Int]()
    @State var isFavorite = false
    @Binding var detent: PresentationDetent
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(location.name)
                    .bold()
                    .foregroundColor(location.isActive ? .primary : .secondary)

                if !location.isActive {
                    Text("inline_location_view_inactive")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
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
        .onChange(of: isSearching, perform: { newValue in
            if newValue {
                detent = .large
            }
        })
    }
}

struct InlineLocationView_Previews: PreviewProvider {
    static var previews: some View {
        InlineLocationView(location: Location.exampleLocation(), detent: .constant(.large))
    }
}
