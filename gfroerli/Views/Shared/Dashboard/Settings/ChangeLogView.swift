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
                Section("Version " + String(items.version)) {
                    ForEach(items.items) { item in
                        Label {
                            Text(item.description)
                        } icon: {
                            item.changeType.image()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Changelog")
    }
}

struct ChangeLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeLogView()
        }
    }
}
