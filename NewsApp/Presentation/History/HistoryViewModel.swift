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
    
    private let searchHistoryRepository: SearchHistoryRepository
    
    init(searchHistoryRepository: SearchHistoryRepository) {
        self.searchHistoryRepository = searchHistoryRepository
    }
    
    func fetchHistory() {
        history = searchHistoryRepository.fetchSearches()
    }
    
    func deleteFromHistory(search: SearchHistoryItem) {
        searchHistoryRepository.removeSearch(search)
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
        searchHistoryRepository.clearSearches()
        fetchHistory()
    }
}
