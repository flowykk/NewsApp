protocol FavouriteArticlesUseCase {

    func fetchFavourites(completion: @escaping (Result<[Article], Error>) -> Void)
    func clearFavourites()
}

final class DefaultFavouriteArticlesUseCase: FavouriteArticlesUseCase {

    private let repository: FavouriteArticlesRepository

    init(repository: FavouriteArticlesRepository) {
        self.repository = repository
    }

    func fetchFavourites(completion: @escaping (Result<[Article], Error>) -> Void) {
        repository.fetchFavourites { result in
            completion(result)
        }
    }

    func clearFavourites() {
        repository.clearFavourites()
    }
}
