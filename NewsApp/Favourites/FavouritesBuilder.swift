import Foundation
import UIKit

final class FavouritesBuilder {
    static func build() -> UIViewController {
        let viewModel = FavouritesViewModel()
        let view = FavouritesViewController()
        
        let webRouter = WebRouter()
        let router = FavouritesRouter(webRouter: webRouter)
        
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        
        return view
    }
}
