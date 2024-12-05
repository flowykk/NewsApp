final class DefaultFavouriteArticlesRepository: FavouriteArticlesRepository {

    private let storage = SwiftDataArticlesStorage.shared

    func fetchFavourites(completion: @escaping (Result<[Article], Error>) -> Void) {
        storage.fetchArticles { result in
            completion(result)
        }
    }

    func clearFavourites() {
        storage.clearArticles()
    }
}
