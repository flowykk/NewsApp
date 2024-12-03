import Foundation

protocol HistoryRouterProtocol {
    var view: HistoryViewController? { get }
    
    func navigateToNews()
}

final class HistoryRouter: HistoryRouterProtocol {
    weak var view: HistoryViewController?
    
    func navigateToNews() {
        view?.navigationController?.popViewController(animated: true)
    }
}
