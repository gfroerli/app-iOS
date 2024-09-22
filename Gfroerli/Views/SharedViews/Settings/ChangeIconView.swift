//
//  ChangeIconView.swift
//  Gfroerli
//
//  Created by Marc on 16.09.2024.
//

import SwiftUI
import UIKit
struct ChangeIconView: View {
    
    private enum AppIcons: CaseIterable {
        case original, summerSunset, winterSunset, night
        
        var iconName: String? {
            switch self {
            case .original: nil
            case .summerSunset: "SummerSunset"
            case .winterSunset: "WinterSunset"
            case .night: "Night"
            }
        }
        
        var displayName: LocalizedStringKey {
            switch self {
            case .original: "Default"
            case .summerSunset: "icon_summer_sunset"
            case .winterSunset: "icon_winter_sunset"
            case .night: "icon_midnight"
            }
        }
        
        var preview: UIImage {
            switch self {
            case .original:
                UIImage(named: "IconOriginal")!
            case .summerSunset:
                UIImage(named: "IconSummerSunsetFull")!
            case .winterSunset:
                UIImage(named: "IconWinterSunsetFull")!
            case .night:
                UIImage(named: "IconNightFull")!
            }
        }
    }

    var body: some View {
        List {
            ForEach(AppIcons.allCases, id: \.self) { icon in
                Button {
                    UIApplication.shared.setAlternateIconName(icon.iconName)
                } label: {
                    HStack {
                        Image(uiImage: icon.preview)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                        Text(icon.displayName)
                    }
                    .frame(height: 75)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("settings_view_item_icon")
    }
}

#Preview {
    ChangeIconView()
}
