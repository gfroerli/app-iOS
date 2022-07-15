//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import WidgetKit
import StoreKit
import CoreLocation

struct SettingsView: View {
    @State var alertShowing = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    SettingsHeaderView()
                    // MARK: - General
                    Section(header: Text("General")) {
                        // FAQ
                        HStack {
                            NavigationLink(destination: FAQView(), label: {
                                Label(
                                    title: { Text("FAQ").foregroundColor(Color("textColor"))},
                                    icon: {
                                        Image(systemName: "info.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .padding(3)
                                            .frame(width: 25, height: 25, alignment: .center)
                                            .background(.blue)
                                            .cornerRadius(3)
                                    })
                            })}
                        
                        // Changelog
                        /*HStack {
                            NavigationLink(destination: ChangelogView(), label: {
                                Label(
                                    title: { Text("Changelog").foregroundColor(Color("textColor"))},
                                    icon: {
                                        Image(systemName: "sparkles")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .padding(3)
                                            .frame(width: 25, height: 25, alignment: .center)
                                            .background(.green)
                                            .cornerRadius(3)
                                    })
                            })}*/
                        
                        // Language
                        Button(action: {
                            UIApplication.shared.open(
                                URL.init(string: UIApplication.openSettingsURLString)!,
                                options: [:],
                                completionHandler: nil
                            )
                            
                        }, label: {
                            Label(
                                title: { Text("Change Language").foregroundColor(Color("textColor"))},
                                icon: {
                                    Image(systemName: "globe")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(.blue)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .cornerRadius(3)
                                })
                        })
                    }
                    
                    // MARK: - Links
                    Section(header: Text("Links")) {
                        Button(action: {
                            var components = URLComponents(
                                url: URL(string: "https://apps.apple.com/us/app/gfr%C3%B6r-li/id1451431723")!,
                                resolvingAgainstBaseURL: false
                            )
                            
                            components?.queryItems = [
                                URLQueryItem(name: "action", value: "write-review")
                            ]
                            guard let writeReviewURL = components?.url else {
                                return
                            }
                            openURL(writeReviewURL)
                            
                        }, label: {
                            Label(
                                title: { Text("Rate")
                                    .foregroundColor(Color("textColor")) },
                                icon: {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .background(Color.red)
                                        .cornerRadius(3)
                                })
                        })
                        
                        // Contact
                        Button(action: {
                            let email = "appdev@coredump.ch"
                            // swiftlint:disable line_length
                            let subject = "Feedback iOS Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
                            let body = getEmailBody()
                            // swiftlint:disable line_length
                            guard let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")")
                            else { return }
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            Label(
                                title: { Text("Contact").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image(systemName: "envelope.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .background(Color.blue)
                                        .cornerRadius(3)
                                })
                        })
                        
                        // Privacy
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li/about")!, label: {
                            Label(
                                title: { Text("Privacy Policy").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image(systemName: "hand.raised.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .background(Color.blue)
                                        .cornerRadius(3)
                                })
                        })
                        
                        // www.gfrör.li
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li")!, label: {
                            Label(
                                title: { Text("gfrör.li").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image(systemName: "safari")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .padding(4)
                                        .background(Color.white)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .cornerRadius(3)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.gray, lineWidth: 0.2)
                                        )
                                })
                        })
                        
                        // www.coredump.ch
                        Link(destination: URL(string: "https://www.coredump.ch/")!, label: {
                            Label(
                                title: { Text("coredump.ch").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image(systemName: "safari")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .padding(4)
                                        .background(Color.white)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .cornerRadius(3)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.gray, lineWidth: 0.2)
                                        )
                                })
                        })
                        
                        // Twitter
                        Link(destination: URL(string: "https://twitter.com/coredump_ch")!, label: {
                            Label(
                                title: { Text("@coredump_ch").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image("twitterIcon")
                                        .resizable()
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .cornerRadius(3)
                                })
                        })
                        
                        // GitHub
                        Link(destination: URL(string: "https://github.com/gfroerli")!, label: {
                            Label(
                                title: { Text("Code on Github").foregroundColor(Color("textColor")) },
                                icon: {
                                    Image("githubIcon")
                                        .resizable()
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .cornerRadius(3)
                                })
                        })
                    } // End Section
                } // End List
                .listStyle(InsetGroupedListStyle())
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().makePreViewModifier()
    }
}

// MARK: - SettingsHeaderView
struct SettingsHeaderView: View {
    
    private var lastVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "_"
    
    var body: some View {
        HStack {
            
            Image("AppIcon-1024")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text("Gfrör.li")
                    .font(.title)
                    .bold()
                Text("Version: \(lastVersion)")
                    .foregroundColor(.secondary)
                Text("by Marc & Niklas\nfor Coredump Rapperswil")
                    .foregroundColor(.secondary)
            }
            .lineLimit(2)
            .minimumScaleFactor(0.1)
            .padding(.vertical, 10)
        }
    }
}
