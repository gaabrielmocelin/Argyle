//
//  SearchViewModel.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

enum SearchState: Equatable {
    case empty
    case loading
    case loaded(items: [LinkItem])
    case error(NetworkError)
}

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateState(_ state: SearchState)
}

final class SearchViewModel {
    private let networkService: NetworkService

    private var searchTimer: Timer?

    private(set) var state: SearchState = .empty {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didUpdateState(self.state)
            }
        }
    }

    weak var delegate: SearchViewModelDelegate? {
        didSet { delegate?.didUpdateState(state) }
    }

    init(networkService: NetworkService = RealNetworkService()) {
        self.networkService = networkService
    }

    func search(for searchText: String?) {
        searchTimer?.invalidate()

        // Debouncer timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.fetchItems(searchText: searchText)
        }
    }

    func fetchItems(searchText: String?) {
        guard let searchText, searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 else {
            state = .empty
            return
        }

        state = .loading

        networkService.request(SearchLinkItemsRequest(text: searchText)) { [weak self] result in
            switch result {
            case .success(let items):
                self?.state = .loaded(items: items)
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }
}
