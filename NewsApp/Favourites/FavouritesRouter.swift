import Foundation
import UIKit

protocol FavouritesRouterProtocol {
    
    var view: FavouritesViewController? { get set }
    
    func navigateToNews()
    
    func showArticleInBrowser(urlString: String)
    func presentClearFavouritesAlert()
    func presentEmptyFavouritesAlert()
}

final class FavouritesRouter: FavouritesRouterProtocol {
    
    weak var view: FavouritesViewController?
    
    private let webRouter: WebRouterProtocol
    
    init(webRouter: WebRouterProtocol) {
        self.webRouter = webRouter
    }
    
    func showArticleInBrowser(urlString: String) {
        webRouter.openWebPage(from: view, urlString: urlString)
    }
    
    func navigateToNews() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentClearFavouritesAlert() {
        let alertController = UIAlertController(
            title: "Confirm clearing favourites",
            message: "Are you sure you want to clear favourite articles? You will not be able to undo this action!",
            preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.view?.viewModel?.clearFavourites()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        view?.present(alertController, animated: true)
    }
    
    func presentEmptyFavouritesAlert() {
        AlertHelper.shared.showDefaultAlert(
            from: view,
            withTitle: "Empty favourites",
            message: "You have no favourite articles!"
        )
    }
}
