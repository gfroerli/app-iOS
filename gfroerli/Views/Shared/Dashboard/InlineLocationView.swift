//
//  InlineLocationView.swift
//  gfroerli
//
//  Created by Marc on 15.10.22.
//

import GfroerliAPI
import SwiftUI

struct InlineLocationView: View {
    
    let location: Location
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack {
                Text(location.name)
                    .bold()
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(location.latestTemperatureString)
                Text(location.lastTemperatureDateString)
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

struct InlineLocationView_Previews: PreviewProvider {
    static var previews: some View {
        InlineLocationView(location: Location.exampleLocation())
    }
}
