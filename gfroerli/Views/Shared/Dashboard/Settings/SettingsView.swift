//
//  SettingsView.swift
//  gfroerli
//
//  Created by Marc Kramer on 18.06.22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode

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
                    Text("Close")
                }
            })
            .navigationTitle("Settings")
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
                    .frame(maxWidth: 150)
                
                VStack(alignment: .leading) {
                    Text("Gfrör.li")
                        .foregroundColor(.primary)
                        .font(.title)
                        .bold()
                    Text("Version: \(config.lastVersion)")
                    Text("by Marc")
                    Text("for Coredump Rapperswil")
                }
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
        Section(header: Text("General")) {
            // FAQ
            NavigationLink {
                FAQView()
            } label: {
                Label(title: {
                    Text("FAQ")
                }, icon: {
                    SettingsThumbnailView(imageName: "info.circle", backgroundColor: .blue)
                })
            }
            
            // Changelog
            NavigationLink {
                ChangeLogView()
            } label: {
                Label {
                    Text("Changelog")
                } icon: {
                    SettingsThumbnailView(imageName: "sparkles", backgroundColor: .green)
                }
            }
            
            // Language
            Button {
                openLanguageSettings()
            } label: {
                Label {
                    Text("Language")
                } icon: {
                    SettingsThumbnailView(imageName: "globe", backgroundColor: .blue)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func openLanguageSettings() {
        UIApplication.shared.open(
            URL.init(string: UIApplication.openSettingsURLString)!,
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
                    Text("Rate")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "heart.fill", backgroundColor: .red)
                }
            }
            
            // Email
            Link(destination: config.emailURL) {
                Label {
                    Text("Contact")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "envelope.fill", backgroundColor: .blue)
                }
            }
            
            // Privacy Policy
            Link(destination: config.privacyPolicyURL) {
                Label {
                    Text("Privacy Policy")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "hand.raised.fill", backgroundColor: .black)
                }
            }
            
            // Gfroerli Web
            Link(destination: config.gfroerliURL) {
                Label {
                    Text("gfrör.li")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "safari", backgroundColor: .blue)
                }
            }
            
            // Coredump Web
            Link(destination: config.coredumpURL) {
                Label {
                    Text("coredump.ch")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "safari", backgroundColor: .green)
                }
            }
            
            // Coredump Twitter
            Link(destination: config.twitterURL) {
                Label {
                    Text("@coredump_ch")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "bird.fill", backgroundColor: .green)
                }
            }
            
            // GitHub
            Link(destination: config.githubURL) {
                Label {
                    Text("View Code on GitHub")
                        .foregroundColor(Color("textColor"))
                } icon: {
                    SettingsThumbnailView(imageName: "flame.fill", backgroundColor: .black)
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
