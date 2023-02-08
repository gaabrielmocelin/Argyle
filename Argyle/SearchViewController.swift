//
//  ViewController.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel = SearchViewModel()
    private lazy var dataSource = makeDataSource()

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    init() {
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
        viewModel.delegate = self
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = makeDataSource()
        tableView.delegate = self

        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            cell.contentConfiguration = UIHostingConfiguration {
                LinkItemView(linkItem: item)
            }

            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Search Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(for: searchController.searchBar.text)
    }
}

// MARK: - ViewModel Delegate
extension SearchViewController: SearchViewModelDelegate {
    func didUpdateState(_ state: SearchState) {
        activityIndicator.stopAnimating()
        label.isHidden = true
        set(items: [])

        switch state {
        case .empty:
            label.isHidden = false
            label.text = "Just type the name of the Link Item and we will search it for you!"

        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

        case .loaded(let items):
            set(items: items)

        case .error:
            label.isHidden = false
            label.text = "Ops! Something went wrong, try it later!"
        }
    }
}
