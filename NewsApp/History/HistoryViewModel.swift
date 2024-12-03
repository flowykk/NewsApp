import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    var router: HistoryRouterProtocol? { get set }
    var history: [SearchHistoryItem] { get set }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)? { get set }
    
    func fetchHistory()
    func backButtonTapped()
}

final class HistoryViewModel: HistoryViewModelDelegate {
    var router: HistoryRouterProtocol?
    
    var history = [SearchHistoryItem]() {
        didSet {
            didFetchedHistory?(history)
        }
    }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)?
    
    func fetchHistory() {
        history = [
            SearchHistoryItem(title: "Apple"),
            SearchHistoryItem(title: "Google"),
            SearchHistoryItem(title: "Microsoft")
        ]
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
}
