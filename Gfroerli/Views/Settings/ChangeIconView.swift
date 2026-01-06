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
        case original, summerSunset, winterSunset, midnight
        
        var iconName: String? {
            switch self {
            case .original: nil
            case .summerSunset: "IconSummerSunset"
            case .winterSunset: "IconWinterSunset"
            case .midnight: "IconMidnight"
            }
        }
        
        var displayName: LocalizedStringKey {
            switch self {
            case .original: "icon_default"
            case .summerSunset: "icon_summer_sunset"
            case .winterSunset: "icon_winter_sunset"
            case .midnight: "icon_midnight"
            }
        }
        
        var preview: UIImage {
            switch self {
            case .original:
                UIImage(resource: .defaultIcon)
                
            case .summerSunset:
                UIImage(resource: .summerSunset)

            case .winterSunset:
                UIImage(resource: .winterSunset)

            case .midnight:
                UIImage(resource: .midnight)
            }
        }
    }

    var body: some View {
        List {
            ForEach(AppIcons.allCases, id: \.self) { icon in
                HStack {
                    Image(uiImage: icon.preview)
                        .resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    Text(icon.displayName)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.setAlternateIconName(icon.iconName)
                }
            }
        }
        .navigationTitle("settings_view_item_icon")
    }
}

#Preview {
    ChangeIconView()
}
