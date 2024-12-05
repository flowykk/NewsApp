import Foundation
import UIKit

final class HistoryBuilder {
    
    static func build() -> UIViewController {
        let historyRepoitory = DefaultSearchHistoryRepository()
        let viewModel = HistoryViewModel(searchHistoryRepository: historyRepoitory)
        
        let view = HistoryViewController()
        let router = HistoryRouter()
        
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        
        return view
    }
}
