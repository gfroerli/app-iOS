//
//  InlineLocationView.swift
//  gfroerli
//
//  Created by Marc on 15.10.22.
//

import GfroerliBackend
import SwiftUI

struct InlineLocationView: View {
    
    @Environment(\.isSearching) var isSearching

    @AppStorage("favorites") private var favorites = [Int]()
    
    @State private var isFavorite = false

    @Binding var detent: PresentationDetent
    
    let location: Location

    // MARK: - Body

    var body: some View {
        
        HStack {
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

// MARK: - Preview

struct InlineLocationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InlineLocationView(detent: .constant(.large), location: Location.exampleLocation())
                .background(.red)
            
            InlineLocationView(detent: .constant(.large), location: Location.inactiveExampleLocation())
                .background(.red)
        }
    }
}
