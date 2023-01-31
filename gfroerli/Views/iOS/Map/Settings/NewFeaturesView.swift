//
//  ChangeLogView.swift
//  gfroerli
//
//  Created by Marc Kramer on 18.06.22.
//

import SwiftUI

struct NewFeaturesView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("What's New to Gfrör.li")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            ForEach(NewFeatures.latestFeatures) { note in
                
                HStack(alignment: .top) {
                    
                    Image(systemName: note.imageName)
                        .resizable()
                        .foregroundColor(.accentColor.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(note.title)
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                        
                        Text(note.text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            
            Spacer()

            Button("Get Started") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .tint(.accentColor)
            .buttonStyle(.bordered)
            
            Spacer()
        }
    }
}

struct NewFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        NewFeaturesView()
    }
}
