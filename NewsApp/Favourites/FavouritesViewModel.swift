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
        ArticlesDatabaseManager.shared.fetchArticles { result in
            switch result {
            case .success(let articles):
                print(articles)
            case .failure:
                return
            }
        }
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
        
        ArticlesDatabaseManager.shared.saveArticle(
            article: ArticleDTO(
                url: "123",
                sourceName: "123",
                title: "123",
                articleDescription: "123",
                urlToImage: "123",
                publishedAt: "123"
            )
        )
    }
}
