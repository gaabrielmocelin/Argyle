//
//  SearchViewModel.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

final class SearchViewModel {
    var items: [LinkItem] = []

    func search(for searchText: String) {
        guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 else {
            items = []
            return
        }

        RealNetworkService().request(SearchLinkItemsRequest(text: searchText)) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                print(items)
            case .failure(let error):
                self?.items = []
                print(error)
            }
        }
    }
}

struct LinkItem: Hashable, Decodable {
    let name: String
}
