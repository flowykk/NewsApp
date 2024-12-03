import Foundation

protocol FavouritesViewModelDelegate: AnyObject {
    var router: FavouritesRouterProtocol? { get set }
    var favourites: [Article] { get set }
    var didFetchedFavourites: (([Article]) -> Void)? { get set }
    
    func fetchFavourites()
    
    func backButtonTapped()
}

final class FavouritesViewModel: FavouritesViewModelDelegate {
    var router: FavouritesRouterProtocol?
    
    var favourites = [Article]() {
        didSet {
            didFetchedFavourites?(favourites)
        }
    }
    
    var didFetchedFavourites: (([Article]) -> Void)?
    
    func fetchFavourites() {
        favourites = []
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
}
