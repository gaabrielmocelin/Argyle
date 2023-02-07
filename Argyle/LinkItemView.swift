//
//  LinkItemView.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import SwiftUI

struct LinkItemView: View {
    let linkItem: LinkItem

    var body: some View {
        HStack(spacing: 16) {
            Image("")
                .frame(width: 75, height: 75)
                .background(Color.gray)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(linkItem.name)
                    .font(.headline)

                Text("description")
                    .font(.body)
            }

            Spacer()
        }
        .padding()
    }
}

struct LinkItemView_Previews: PreviewProvider {
    static var previews: some View {
        LinkItemView(linkItem: .init(name: "Test"))
    }
}
