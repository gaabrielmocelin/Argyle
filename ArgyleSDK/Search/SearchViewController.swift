//
//  ViewController.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {

    // MARK: Properties
    private let presenter: SearchPresenter
    private lazy var dataSource = makeDataSource()

    // MARK: Views
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    // MARK: Life Cycle
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupActivityIndicator()
        setupLabel()
        presenter.delegate = self
    }

    // MARK: Setup UI
    private func setupTableView() {
        tableView.register(type: LinkItemCell.self)
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.separatorStyle = .none

        view.addSubviewMatchingConstraints(tableView)
    }

    private func setupSearchBar() {
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupLabel() {
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)

        view.addSubview(label) { view, label in
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            label.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator) { view, activityIndicator in
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        }
    }

    // MARK: Update UI
    private func set(items: [LinkItem]) {
        var snapshot = SearchSnapshot()
        snapshot.appendSections(TableSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
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
            let cell = tableView.dequeueReusableCell(for: indexPath, of: LinkItemCell.self)
            cell.setup(presenter: .init(item: item))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard case .loaded(let items) = presenter.state else { return }

        let hostController = UIHostingController(rootView: LinkItemDetailView(linkItem: items[indexPath.row]))
        hostController.modalPresentationStyle = .pageSheet
        hostController.sheetPresentationController?.detents = [.medium()]
        hostController.sheetPresentationController?.prefersGrabberVisible = true
        present(hostController, animated: true)
    }
}

// MARK: - Search Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.search(for: searchController.searchBar.text)
    }
}

// MARK: - ViewModel Delegate
extension SearchViewController: SearchPresenterDelegate {
    func didUpdateState(_ state: SearchState) {
        activityIndicator.stopAnimating()
        label.isHidden = true
        set(items: [])

        switch state {
        case .empty:
            label.isHidden = false
            label.text = Strings.Search.emptyState

        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

        case .loaded(let items):
            set(items: items)

        case .error:
            label.isHidden = false
            label.text = Strings.Search.somethingWentWrong
        }
    }
}
