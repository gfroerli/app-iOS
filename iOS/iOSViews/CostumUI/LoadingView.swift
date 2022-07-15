//
//  LoadingView.swift
//  iOS
//
//  Created by Marc Kramer on 18.09.20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                    .padding(.bottom, 2)
                Text("LOADING").foregroundColor(.secondary)
                Spacer()
            }
            Spacer()
        }.padding()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
