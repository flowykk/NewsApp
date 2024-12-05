protocol NewsRouterProtocol {

    var view: NewsViewController? { get set }

    func showArticleInBrowser(urlString: String)
    func navigateToHistory()
    func navigateToFavourites()

    func presentNoDataAlert()
}
