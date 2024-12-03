import Foundation
import SafariServices


protocol NewsRouterProtocol {
    var view: NewsViewController? { get set }
    
    func showArticleInBrowser(urlString: String)
}

final class NewsRouter: NewsRouterProtocol {
    weak var view: NewsViewController?
    
    func showArticleInBrowser(urlString: String) {
        guard let webURL = URL(string: urlString) else {
            return
        }
    
        let safariVC = SFSafariViewController(url: webURL)
        view?.present(safariVC, animated: true, completion: nil)
    }
}
