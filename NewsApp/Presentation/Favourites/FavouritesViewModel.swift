import RxSwift
import RxCocoa

protocol FavouritesViewModelDelegate: AnyObject {
    
    var router: FavouritesRouterProtocol? { get set }
    var favourites: BehaviorRelay<[Article]> { get set }
    
    func fetchFavourites()
    
    func articleDidTapped(with urlString: String)
    func backButtonTapped()
    func clearFavouritesButtonTapped()
    
    func clearFavourites()
}

final class FavouritesViewModel: FavouritesViewModelDelegate {
    
    var router: FavouritesRouterProtocol?
    
    var favourites = BehaviorRelay<[Article]>(value: [])
    
    private let favouritesUseCase: FavouriteArticlesUseCase

    init(favouritesUseCase: FavouriteArticlesUseCase) {
        self.favouritesUseCase = favouritesUseCase
    }
    
    func fetchFavourites() {
        favouritesUseCase.fetchFavourites { [weak self] result in
            switch result {
            case .success(let articles):
                self?.favourites.accept(articles)
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
        if favourites.value.isEmpty {
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
