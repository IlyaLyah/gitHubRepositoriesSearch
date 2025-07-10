//
//  AppCoordinator.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import UIKit

public class AppCoordinator {
    private let navigator: UINavigationController
    
    init(window: UIWindow) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.navigator = navigationController
        
        start()
    }
    
    private func start() {
        searchRepositoriesFlow()
    }
    
    private func searchRepositoriesFlow() {
        let viewModel = SearchRepositoriesViewModelImpl(
            repositoryFetcher: RepositoryFetcherServiceImpl(repositoriesSearchFetcher: RepositorySearchFetcherImpl()),
            imageLoader: ImageLoaderImpl(),
            router: self
        )
        let controller = SearchRepositoriesViewController(viewModel: viewModel)
        self.navigator.pushViewController(controller, animated: true)
    }
}

extension AppCoordinator: SearchRepositoriesRouter {
    public func showDetails(for repository: Repository) {
        let viewModel = RepositoryDetailsViewModelImpl(
            repository: repository,
            imageLoader: ImageLoaderImpl(),
            router: self
        )
        let controller = RepositoryDetailsViewController(viewModel: viewModel)
        self.navigator.pushViewController(controller, animated: true)
    }
    
    public func showError(error: Error?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.navigator.topViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

extension AppCoordinator: RepositoryDetailsRouter {
    public func openLink(link: URL) {
        UIApplication.shared.open(link)
    }
}
