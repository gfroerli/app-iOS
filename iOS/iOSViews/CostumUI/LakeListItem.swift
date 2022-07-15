//
//  SensorListItem.swift
//  iOS
//
//  Created by Marc Kramer on 04.12.20.
//

import SwiftUI

struct LakeListItem: View {
    var lake: Lake
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(lake.name).foregroundColor(colorScheme == .dark ? Color.white : Color.black).font(.headline)
                Text("Sensors:" + String(lake.sensors.count))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black).font(.caption)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)

        }                .padding()

        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(15)
    }
}

struct SensorListItem_Previews: PreviewProvider {
    static var previews: some View {
     EmptyView()

    }
}
