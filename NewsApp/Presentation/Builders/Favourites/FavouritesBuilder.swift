import UIKit

final class FavouritesBuilder {

    static func build() -> UIViewController {
        let repository = DefaultFavouriteArticlesRepository()
        let useCase = DefaultFavouriteArticlesUseCase(repository: repository)
        let viewModel = FavouritesViewModel(favouritesUseCase: useCase)

        let view = FavouritesViewController()

        let webRouter = WebRouter()
        let router = FavouritesRouter(webRouter: webRouter)

        view.viewModel = viewModel
        viewModel.router = router
        router.view = view

        return view
    }
}
