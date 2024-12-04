import Foundation

protocol FavouritesViewModelDelegate: AnyObject {
    var router: FavouritesRouterProtocol? { get set }
    var favourites: [Article] { get set }
    var didFetchedFavourites: (([Article]) -> Void)? { get set }
    
    func fetchFavourites()
    
    func backButtonTapped()
    func clearFavouritesButtonTapped()
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
        ArticlesDatabaseManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.favourites = articles.map { $0.toArticle() }
            case .failure:
                return
            }
        }
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
    
    func clearFavouritesButtonTapped() {
        clearFavourites()
    }
    
    private func clearFavourites() {
        ArticlesDatabaseManager.shared.clearArticles()
    }
}
