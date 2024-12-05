protocol FavouriteArticlesRepository {
    
    func fetchFavourites(completion: @escaping (Result<[Article], Error>) -> Void)
    func clearFavourites()
}
