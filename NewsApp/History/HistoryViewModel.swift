import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    var router: HistoryRouterProtocol? { get set }
    var data: [SearchHistoryItem] { get set }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)? { get set }
    
    func fetchHistory()
}

final class HistoryViewModel: HistoryViewModelDelegate {
    var router: HistoryRouterProtocol?
    
    var data = [SearchHistoryItem]() {
        didSet {
            didFetchedHistory?(data)
        }
    }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)?
    
    func fetchHistory() {
        data = [
            SearchHistoryItem(title: "Apple"),
            SearchHistoryItem(title: "Google"),
            SearchHistoryItem(title: "Microsoft")
        ]
    }
}
