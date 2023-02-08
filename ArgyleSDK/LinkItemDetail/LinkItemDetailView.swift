//
//  LinkItemDetailView.swift
//  ArgyleSDK
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import SwiftUI

struct LinkItemDetailView: View {
    let linkItem: LinkItem

    var body: some View {
        HStack(spacing: 16) {
            Image("")
                .frame(width: 75, height: 75)
                .background(Color.secondary)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(linkItem.name)
                    .font(.headline)

                Text(linkItem.kind)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}

struct LinkItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LinkItemDetailView(linkItem: .init(name: "Amazon", kind: "Employer", logoURL: ""))
    }
}
