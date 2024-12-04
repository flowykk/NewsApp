import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    var router: HistoryRouterProtocol? { get set }
    var history: [SearchHistoryItem] { get set }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)? { get set }
    
    func fetchHistory()
    func deleteFromHistory(search: SearchHistoryItem)
    
    func clearHistoryButtonTapped()
    func backButtonTapped()
    
    func clearHistory()
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
        history = HistoryDataManager.shared.fetchSearches()
    }
    
    func deleteFromHistory(search: SearchHistoryItem) {
        HistoryDataManager.shared.removeSearch(search)
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
    
    func clearHistoryButtonTapped() {
        if history.isEmpty {
            router?.presentEmptyHistoryAlert()
        } else {
            router?.presentClearHistoryAlert()
        }
    }
    
    func clearHistory() {
        HistoryDataManager.shared.clearSearches()
        fetchHistory()
    }
}
