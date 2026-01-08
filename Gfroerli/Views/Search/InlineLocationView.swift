//
//  InlineLocationView.swift
//  gfroerli
//
//  Created by Marc on 15.10.22.
//

import GfroerliBusinessMocks
import GfroerliBusinessProtocols
import SwiftUI

struct InlineLocationView: View {
    @Environment(\.isSearching) var isSearching

    @AppStorage("favorites") private var favorites = [Int]()

    @State private var isFavorite = false

    let location: BusinessLocationProtocol

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(location.name)
                        .bold()
                        .foregroundColor(location.isActive ? .primary : .secondary)
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
            }
           
            Spacer()

            VStack(alignment: .trailing) {
                Text(location.lastTemperatureString)
                    .bold()
                Text(location.lastTemperatureDateString)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            isFavorite = favorites.contains(location.id)
        }
    }
}

#Preview {
    List {
        InlineLocationView(location: BusinessLocationMock.exampleLocation1)
    }
}
