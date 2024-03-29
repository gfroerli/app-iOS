//
//  SettingsView.swift
//  gfroerli
//
//  Created by Marc Kramer on 18.06.22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                SettingsHeaderView()
                SettingsGeneralSectionView()
                SettingsLinksSectionView()
            }
            .toolbar(content: {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("settings_view_close")
                }
            })
            .navigationTitle("settings_view_title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Header

struct SettingsHeaderView: View {
    
    typealias config = AppConfiguration.Settings

    var body: some View {
        Section {
            HStack {
                Image("IconBig")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                    .frame(maxWidth: 100)
                
                VStack(alignment: .leading) {
                    Text("settings_view_app_title")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .bold()
                    Text("settings_view_app_version") + Text(config.lastVersion)
                    Text("settings_view_app_creator")
                    Text("settings_view_app_coredump")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.1)
                .padding(.vertical, 10)
            }
        }
    }
}

// MARK: - General

struct SettingsGeneralSectionView: View {
    var body: some View {
        Section(header: Text("settings_view_header_general")) {
            // FAQ
            // NavigationLink {
            //    FAQView()
            // } label: {
            //    Label(title: {
            //        Text("settings_view_item_FAQ")
            //    }, icon: {
            //        SettingsThumbnailView(imageName: "info.circle", backgroundColor: .accentColor)
            //    })
            // }
            
            // Change log
            NavigationLink {
                ChangeLogView()
            } label: {
                Label {
                    Text("settings_view_item_changelog")
                } icon: {
                    SettingsThumbnailView(imageName: "sparkles", backgroundColor: .green)
                }
            }
            
            // Language
            Button {
                openLanguageSettings()
            } label: {
                Label {
                    Text("settings_view_item_language")
                } icon: {
                    SettingsThumbnailView(imageName: "globe", backgroundColor: .accentColor)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func openLanguageSettings() {
        UIApplication.shared.open(
            URL(string: UIApplication.openSettingsURLString)!,
            options: [:],
            completionHandler: nil
        )
    }
}

// MARK: - Links

struct SettingsLinksSectionView: View {
    @Environment(\.openURL) var openURL

    typealias config = AppConfiguration.Settings
    
    var body: some View {
        Section(header: Text("Links")) {
            // Rate
            Button {
                openURL(config.reviewURL)
            } label: {
                Label {
                    Text("settings_view_item_review")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "heart.fill", backgroundColor: .red)
                }
            }
            
            // Privacy Policy
            Link(destination: config.privacyPolicyURL) {
                Label {
                    Text("settings_view_item_policy")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "hand.raised.fill", backgroundColor: .black)
                }
            }
            
            // Gfroerli Web
            Link(destination: config.gfroerliURL) {
                Label {
                    Text("settings_view_item_gfroerli_web")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "safari", backgroundColor: .accentColor)
                }
            }
            
            // Coredump Web
            Link(destination: config.coredumpURL) {
                Label {
                    Text("settings_view_item_coredump_web")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "safari", backgroundColor: .green)
                }
            }
            
            // Coredump Mastodon
            Link(destination: config.mastodonCoreDumpURL) {
                Label {
                    Text("settings_view_item_coredump_mastodon")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailAssetView(imageName: "mastodon", backgroundColor: .purple)
                }
            }
            
            // GitHub
            Link(destination: config.githubURL) {
                Label {
                    Text("settings_view_item_github")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailAssetView(imageName: "github.fill", backgroundColor: .black)
                }
            }
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
