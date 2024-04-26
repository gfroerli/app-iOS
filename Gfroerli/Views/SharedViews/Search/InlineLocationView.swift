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

    let location: Location

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(location.name ?? "")
                        .bold()
                        .foregroundColor(true ? .primary : .secondary)
                    if isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .imageScale(.small)
                    }
                }
                if !location.isActive {
                    Text("inline_location_view_inactive")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                else {
                    Text("")
                        .font(.callout)
                }
            }
           
            Spacer()

            VStack(alignment: .trailing) {
                Text(location.latestTemperatureString)
                Text(location.lastTemperatureDateString)
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
        .onAppear {
            isFavorite = favorites.contains(location.id)
        }
    }
}

// MARK: - Preview

struct InlineLocationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InlineLocationView(location: Location.exampleLocation())
            InlineLocationView(location: Location.inactiveExampleLocation())
        }
    }
}
