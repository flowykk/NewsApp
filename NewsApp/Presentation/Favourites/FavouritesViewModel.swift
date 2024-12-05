protocol FavouritesViewModelDelegate: AnyObject {
    
    var router: FavouritesRouterProtocol? { get set }
    var favourites: [Article] { get set }
    var didFetchedFavourites: (([Article]) -> Void)? { get set }
    
    func fetchFavourites()
    
    func articleDidTapped(with urlString: String)
    func backButtonTapped()
    func clearFavouritesButtonTapped()
    
    func clearFavourites()
}

final class FavouritesViewModel: FavouritesViewModelDelegate {
    
    var router: FavouritesRouterProtocol?
    
    var favourites = [Article]() {
        didSet {
            didFetchedFavourites?(favourites)
        }
    }
    var didFetchedFavourites: (([Article]) -> Void)?
    
    private let favouritesUseCase: FavouriteArticlesUseCase

    init(favouritesUseCase: FavouriteArticlesUseCase) {
        self.favouritesUseCase = favouritesUseCase
    }
    
    func fetchFavourites() {
        favouritesUseCase.fetchFavourites { [weak self] result in
            switch result {
            case .success(let articles):
                self?.favourites = articles.map { $0 }
            case .failure:
                return
            }
        }
    }
    
    func articleDidTapped(with urlString: String) {
        router?.showArticleInBrowser(urlString: urlString)
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
    
    func clearFavouritesButtonTapped() {
        if favourites.isEmpty {
            router?.presentEmptyFavouritesAlert()
        } else {
            router?.presentClearFavouritesAlert()
        }
    }
    
    func clearFavourites() {
        favouritesUseCase.clearFavourites()
        fetchFavourites()
    }
}
