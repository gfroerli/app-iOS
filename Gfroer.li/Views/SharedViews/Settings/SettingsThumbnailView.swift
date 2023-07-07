//
//  SettingsThumbnailView.swift
//  gfroerli
//
//  Created by Marc Kramer on 18.06.22.
//

import SwiftUI

struct SettingsThumbnailView: View {
    let imageName: String
    let backgroundColor: Color
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .padding(5)
            .frame(width: 25, height: 25, alignment: .center)
            .background(backgroundColor.gradient)
            .cornerRadius(3)
    }
}

struct SettingsThumbnailAssetView: View {
    let imageName: String
    let backgroundColor: Color
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .padding(5)
            .frame(width: 25, height: 25, alignment: .center)
            .background(backgroundColor.gradient)
            .cornerRadius(3)
    }
}

// MARK: - Preview

struct SettingsThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsThumbnailView(imageName: "pin", backgroundColor: .red)
    }
}
