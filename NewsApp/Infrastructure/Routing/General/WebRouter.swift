import UIKit
import SafariServices

class WebRouter: WebRouterProtocol {
    
    func openWebPage(from view: UIViewController?, urlString: String) {
        guard let webURL = URL(string: urlString), let view else { return }
        
        let safariVC = SFSafariViewController(url: webURL)
        view.present(safariVC, animated: true, completion: nil)
    }
}
