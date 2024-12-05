protocol FavouritesRouterProtocol {
    
    var view: FavouritesViewController? { get set }
    
    func navigateToNews()
    
    func showArticleInBrowser(urlString: String)
    func presentClearFavouritesAlert()
    func presentEmptyFavouritesAlert()
}
