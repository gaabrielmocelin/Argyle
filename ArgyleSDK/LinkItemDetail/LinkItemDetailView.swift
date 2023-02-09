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
        VStack(spacing: 24) {
            header
            description
            Spacer()
        }
        .padding()
    }

    var header: some View {
        HStack(spacing: 16) {
            image

            VStack(alignment: .leading, spacing: 8) {
                Text(linkItem.name)
                    .font(.headline)

                Text(linkItem.kind)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical)
    }

   private var image: some View {
        AsyncImage(url: URL(string: linkItem.logoURL ?? "")) { image in
            image
                .resizable()
                .cornerRadius(8)
        } placeholder: {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: .secondarySystemBackground))
                .overlay {
                    Image(systemName: "photo")
                        .tint(Color(uiColor: .label))
                        .frame(width: 25, height: 25)
                }
        }
        .frame(width: 75, height: 75)
    }

    private var description: some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}

struct LinkItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LinkItemDetailView(linkItem: .init(name: "Amazon", kind: "Employer", logoURL: ""))
    }
}
