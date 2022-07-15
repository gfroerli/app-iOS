//
//  WhatsNewView.swift
//  Gfror.li
//
//  Created by Marc on 23.03.21.
//

import SwiftUI

struct WhatsNewView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("What's New to Gfrör.li")
                .font(.largeTitle)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            
            Spacer()
            
            ForEach(WhatsNew.whatsNewNotes) { note in
                
                HStack(alignment: .top) {
                    
                    Image(systemName: note.imageName)
                        .resizable()
                        .foregroundColor(.blue.opacity(0.5))
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(note.title)
                                .bold()
                            Spacer()
                        }
                        
                        Text(note.text)
                            .foregroundColor(.secondary)
                            .padding(.top, 1)
                        
                    }.frame(maxWidth: .infinity)
                    
                }.padding(.vertical)
                    .minimumScaleFactor(0.1)
            }
            
            Spacer()
            Spacer()
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                
            }
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(15)
            
        }
        .padding()
        .onDisappear {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
            UserDefaults(suiteName: "group.ch.gfroerli")?.set(version, forKey: "lastVersion")
        }
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
