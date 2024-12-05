import UIKit

final class NewsBuilder {

    static func build() -> NewsViewController {
        let repository = DefaultNewsRepository()
        let useCase = DefaultNewsUseCase(repository: repository)
        let viewModel = NewsViewModel(newsUseCase: useCase)

        let view = NewsViewController()

        let webRouter = WebRouter()
        let router = NewsRouter(webRouter: webRouter)

        view.viewModel = viewModel
        viewModel.router = router
        router.view = view

        return view
    }
}
