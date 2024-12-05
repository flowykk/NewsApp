import RxSwift
import RxCocoa

protocol HistoryViewModelDelegate: AnyObject {
    var router: HistoryRouterProtocol? { get set }
    var history: BehaviorRelay<[SearchHistoryItem]> { get set }
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)? { get set }
    
    func fetchHistory()
    func deleteFromHistory(search: SearchHistoryItem)
    
    func clearHistoryButtonTapped()
    func backButtonTapped()
    
    func clearHistory()
}

final class HistoryViewModel: HistoryViewModelDelegate {
    
    var router: HistoryRouterProtocol?
    
    var history = BehaviorRelay<[SearchHistoryItem]>(value: [])
    var didFetchedHistory: (([SearchHistoryItem]) -> Void)?
    
    private let searchHistoryRepository: SearchHistoryRepository
    private let disposeBag = DisposeBag()
    
    init(searchHistoryRepository: SearchHistoryRepository) {
        self.searchHistoryRepository = searchHistoryRepository
        
        history
            .asObservable()
            .subscribe(onNext: { [weak self] historyItems in
                self?.didFetchedHistory?(historyItems)
            })
            .disposed(by: disposeBag)
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
