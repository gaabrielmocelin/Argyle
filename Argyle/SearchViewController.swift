//
//  ViewController.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import UIKit

class SearchViewController: UITableViewController {
    private let viewModel: SearchViewModel = SearchViewModel()
    private lazy var dataSource = makeDataSource()

    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTimer: Timer?

    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = makeDataSource()

        var snapshot = SearchSnapshot()
        snapshot.appendSections(TableSection.allCases)
        snapshot.appendItems(viewModel.items)
        dataSource.apply(snapshot)
    }

    private func setupSearchBar() {
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: UITableViewDiffableDataSource
extension SearchViewController {
    private typealias SearchDatasource = UITableViewDiffableDataSource<TableSection, LinkItem>
    private typealias SearchSnapshot = NSDiffableDataSourceSnapshot<TableSection, LinkItem>

    private enum TableSection: Hashable, CaseIterable {
        case searchResults
    }

    private func makeDataSource() -> SearchDatasource {
        SearchDatasource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.name
            return cell
        }
    }
}

// MARK: - Search Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Invalidate and Reinitialise
        searchTimer?.invalidate()

        guard let searchText = searchController.searchBar.text else {
            return
        }

        // Debouncer timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            print(searchText)
//            self?.viewModel.search(for: searchText)
        }
    }
}
