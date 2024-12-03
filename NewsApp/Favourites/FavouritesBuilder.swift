import Foundation
import UIKit

final class FavouritesBuilder {
    static func build() -> UIViewController {
        let viewModel = FavouritesViewModel()
        let view = FavouritesViewController()
        let router = FavouritesRouter()
        
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        
        return view
    }
}
