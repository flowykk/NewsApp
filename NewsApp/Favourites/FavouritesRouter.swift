import Foundation

protocol FavouritesRouterProtocol {
    
    var view: FavouritesViewController? { get set }
    
    func navigateToNews()
}

final class FavouritesRouter: FavouritesRouterProtocol {
    
    weak var view: FavouritesViewController?
    
    func navigateToNews() {
        view?.navigationController?.popViewController(animated: true)
    }
}
