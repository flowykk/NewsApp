import Foundation
import UIKit

protocol HistoryRouterProtocol {
    var view: HistoryViewController? { get }
    
    func navigateToNews()
    func presentClearHistoryAlert()
    func presentEmptyHistoryAlert()
}

final class HistoryRouter: HistoryRouterProtocol {
    weak var view: HistoryViewController?
    
    func navigateToNews() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentClearHistoryAlert() {
        let alertController = UIAlertController(
            title: "Confirm clearing history",
            message: "Are you sure you want to clear search history? You will not be able to undo this action!",
            preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.view?.viewModel?.clearHistory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        view?.present(alertController, animated: true)
    }
    
    func presentEmptyHistoryAlert() {
        AlertHelper.shared.showDefaultAlert(
            from: view,
            withTitle: "Empty history",
            message: "Your search history is already empty!"
        )
    }
}
