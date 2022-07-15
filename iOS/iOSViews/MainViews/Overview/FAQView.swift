//
//  AboutView.swift
//  iOS
//
//  Created by Marc Kramer on 01.01.21.
//

import SwiftUI

struct FAQView: View {
    @State var firstExpanded = false
    @State var secondExpanded = false
    var body: some View {

            VStack {
                GroupBox {
                    DisclosureGroup(isExpanded: $firstExpanded,
                        content: {
                            Text("A1_String")
                        },
                        label: {
                            Text("Q1_String").font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {withAnimation {firstExpanded.toggle()}}
                        })

                    DisclosureGroup(isExpanded: $secondExpanded,
                        content: {
                            Text("A2_String")
                            HStack {
                                Link("www.gfrör.li", destination: URL(string: "https://xn--gfrr-7qa.li/")!)
                                Spacer()
                            }
                        },
                        label: {
                            Text("Q2_String").font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {withAnimation {secondExpanded.toggle()}}
                        })

                }.groupBoxStyle(ColoredGroupBox())
                Spacer()
            }.padding()
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)

    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
