//
//  ChangelogView().swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import SwiftUI

struct ChangeLogView: View {
    let changeLog = ChangeLog.log
    
    var body: some View {
        Form {
            ForEach(changeLog) { items in
                Section("changelog_view_version_header") {
                    ForEach(items.items) { item in
                            Text(item.description)
                        
                    }
                
                }
            }
        }
        .navigationBarTitle("changelog_view_app_title")
    }
}

struct ChangeLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeLogView()
        }
    }
}
