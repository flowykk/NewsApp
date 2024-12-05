// swiftlint:disable identifier_name
final class NewsRouter: NewsRouterProtocol {

    weak var view: NewsViewController?

    private let webRouter: WebRouterProtocol

    init(webRouter: WebRouterProtocol) {
        self.webRouter = webRouter
    }

    func showArticleInBrowser(urlString: String) {
        webRouter.openWebPage(from: view, urlString: urlString)
    }

    func navigateToHistory() {
        let vc = HistoryBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToFavourites() {
        let vc = FavouritesBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func presentNoDataAlert() {
        AlertHelper.shared.showDefaultAlert(
            from: view,
            withTitle: "Nothing to filter",
            message: "There is no data now!"
        )
    }
}
// swiftlint:enable identifier_name
