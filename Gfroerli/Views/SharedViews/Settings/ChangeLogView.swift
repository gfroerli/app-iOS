//
//  ChangelogView().swift
//  gfroerli
//
//  Created by Marc on 05.09.22.
//

import SwiftUI

struct ChangeLogView: View {
    private let changeLog = ChangeLog.log

    // MARK: - Body

    var body: some View {
        Form {
            ForEach(changeLog) { items in
                Section(items.version) {
                    ForEach(items.items) { item in
                        Text(item.description)
                    }
                }
            }
        }
        .navigationBarTitle("changelog_view_app_title")
    }
}

// MARK: - Preview

struct ChangeLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeLogView()
        }
    }
}
