//
//  SearchViewModel.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

struct SearchViewModel {
    var items: [LinkItem] = [
        LinkItem(name: "Test 1"),
        LinkItem(name: "Test 2"),
        LinkItem(name: "Test 3"),
    ]
}

struct LinkItem: Hashable {
    let name: String
}
