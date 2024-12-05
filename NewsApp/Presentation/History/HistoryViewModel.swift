import RxSwift
import RxCocoa

protocol HistoryViewModelDelegate: AnyObject {
    var router: HistoryRouterProtocol? { get set }
    var history: BehaviorRelay<[SearchHistoryItem]> { get set }
    
    func fetchHistory()
    func deleteFromHistory(search: SearchHistoryItem)
    
    func clearHistoryButtonTapped()
    func backButtonTapped()
    
    func clearHistory()
}

final class HistoryViewModel: HistoryViewModelDelegate {
    
    var router: HistoryRouterProtocol?
    
    var history = BehaviorRelay<[SearchHistoryItem]>(value: [])
    
    private let searchHistoryRepository: SearchHistoryRepository
    private let disposeBag = DisposeBag()
    
    init(searchHistoryRepository: SearchHistoryRepository) {
        self.searchHistoryRepository = searchHistoryRepository
    }
    
    func fetchHistory() {
        history.accept(searchHistoryRepository.fetchSearches())
    }
    
    func deleteFromHistory(search: SearchHistoryItem) {
        searchHistoryRepository.removeSearch(search)
    }
    
    func backButtonTapped() {
        router?.navigateToNews()
    }
    
    func clearHistoryButtonTapped() {
        if history.value.isEmpty {
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
