//
//  SearchRepositoriesViewController.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import UIKit

public class SearchRepositoriesViewController: UIViewController {
    private let viewModel: SearchRepositoriesViewModel
    
    private var textUpdatingTimer: Timer? = nil
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocorrectionType = .no
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    private lazy var emptySearchView: RepositoriesEmptyView = {
        let view = RepositoriesEmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    init(viewModel: SearchRepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.searchRepositories(query: "") { [weak self] in
            self?.reloadData()
        }
    }
    
    private func setupUI() {
        title = "Repositories"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            .init(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
            .init(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0),
            .init(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
            .init(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        ])
        
        view.addSubview(emptySearchView)
        NSLayoutConstraint.activate([
            .init(item: emptySearchView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
            .init(item: emptySearchView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0),
            .init(item: emptySearchView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
            .init(item: emptySearchView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        ])
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = self.viewModel.cellViewModels.isEmpty
            self.emptySearchView.isHidden = !self.viewModel.cellViewModels.isEmpty
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        viewModel.searchRepositories(query: searchController.searchBar.text ?? "") { [weak self] in
            self?.reloadData()
        }
    }
}

extension SearchRepositoriesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        textUpdatingTimer?.invalidate()
        textUpdatingTimer = nil
        textUpdatingTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.viewModel.searchRepositories(query: text, completion: {
                self?.reloadData()
            })
        }
    }
}

extension SearchRepositoriesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath)
        guard let cell = cell as? RepositoryTableViewCell, indexPath.row < self.viewModel.cellViewModels.count else {
            return UITableViewCell()
        }
        let viewModel = self.viewModel.cellViewModels[indexPath.row]
        cell.set(viewModel: viewModel)
        return cell
    }
}

extension SearchRepositoriesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.cellViewModels.count {
            viewModel.loadNextRepositories(query: searchController.searchBar.text ?? "") { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < self.viewModel.cellViewModels.count else {
            return
        }
        let repository = self.viewModel.cellViewModels[indexPath.row].repository
        viewModel.select(repository: repository)
    }
}
