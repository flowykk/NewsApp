import Foundation
import UIKit

final class NewsBuilder {
    static func build() -> NewsViewController {
        let viewModel = NewsViewModel()
        let view = NewsViewController()
        let router = NewsRouter()
        
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        
        return view
    }
}
