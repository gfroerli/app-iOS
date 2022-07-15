//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct FavoritesView: View {
    @AppStorage("favorites") private var favorites = [Int]()
    @State var selectedTag: Int?
    @ObservedObject var sensorsVm: SensorListViewModel

    var body: some View {
        NavigationView {
            VStack {
                if favorites.isEmpty {
                    NoFavoritsView()
                } else {
                    List {
                        ForEach(sensorsVm.sensorArray) { sensor in
                            if favorites.contains(sensor.id) {
                                SensorScrollItemSmall(sensor: sensor, selectedTag: $selectedTag)
                            }
                        }
                    }
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}

struct NoFavoritsView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("No Favorites").font(.largeTitle).foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
    }
}
