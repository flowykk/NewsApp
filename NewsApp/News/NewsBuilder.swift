import Foundation
import UIKit

final class NewsBuilder {
    static func build() -> NewsViewController {
        let viewModel = NewsViewModel()
        let view = NewsViewController()
        
        let webRouter = WebRouter()
        let router = NewsRouter(webRouter: webRouter)
        
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        
        return view
    }
}
