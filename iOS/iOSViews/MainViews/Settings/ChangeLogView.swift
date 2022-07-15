//
//  ChangelogView.swift
//  ChangelogView
//
//  Created by Marc Kramer on 14.08.21.
//

import SwiftUI

struct ChangelogView: View {
    
    var body: some View {
        ScrollView {
            Text("OWO")
//            ForEach(ChangeNote.allChangeNotes) { changeNote in
//               // Workaround for bug in iOS 15.0 Beta 5
//                if true {
//                    VStack(alignment: .leading) {
//
//                        HStack {
//                            Text("Version: "+changeNote.version+":")
//                                .font(.title)
//                                .bold()
//                            Spacer()
//                        }
//
//                        if !changeNote.changes.isEmpty {
//                            Text("Changes")
//                                .font(.title2)
//                                .padding(.vertical, 2)
//                            ForEach(changeNote.changes, id: \.self ) {change in
//                                Text("• "+change)
//                            }
//                            .padding(.horizontal)
//                        }
//
//                        if !changeNote.fixes.isEmpty {
//                            Text("Fixes")
//                                .font(.title2)
//                                .padding(.vertical, 2)
//                            ForEach(changeNote.fixes, id: \.self ) {fix in
//                                Text("• "+fix)
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                    .padding()
//                    .boxStyle()
//                }
//            }
        }
        .navigationBarTitle("Changelog", displayMode: .inline)
        .background(Color.systemGroupedBackground)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
