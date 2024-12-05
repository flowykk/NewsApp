import Foundation
import SafariServices

protocol WebRouterProtocol {
    
    func openWebPage(from view: UIViewController?, urlString: String)
}

class WebRouter: WebRouterProtocol {
    
    func openWebPage(from view: UIViewController?, urlString: String) {
        guard let webURL = URL(string: urlString), let view else { return }
        
        let safariVC = SFSafariViewController(url: webURL)
        view.present(safariVC, animated: true, completion: nil)
    }
}

protocol NewsRouterProtocol {
    
    var view: NewsViewController? { get set }
    
    func showArticleInBrowser(urlString: String)
    func navigateToHistory()
    func navigateToFavourites()
    
    func presentNoDataAlert()
}

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
