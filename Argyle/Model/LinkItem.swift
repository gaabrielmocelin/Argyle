//
//  LinkItem.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import SwiftUI

struct LinkItem: Hashable, Decodable, Equatable {
    let name: String
    let kind: String
    let logoURL: String?

    enum CodingKeys: String, CodingKey {
        case name, kind
        case logoURL = "logo_url"
    }
}
