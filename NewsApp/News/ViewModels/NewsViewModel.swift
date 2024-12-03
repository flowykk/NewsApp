import Foundation
import NetworkKit

protocol NewsViewModelDelegate: AnyObject {
    var router: NewsRouterProtocol? { get set }
    var response: NewsResponse { get set }
    var didFetchedNews: ((NewsResponse) -> Void)? { get set }
    
    func fetchNews(keyword: String, page: Int, pageSize: Int)
    func saveToHistory(title: String, totalResults: Int, searchDate: String)
    
    func articleDidTapped(with urlString: String)
    func historyButtonTapped()
}

final class NewsViewModel: NewsViewModelDelegate {
    var router: NewsRouterProtocol?
    
    var response = NewsResponse() {
        didSet {
            didFetchedNews?(response)
        }
    }
    var didFetchedNews: ((NewsResponse) -> Void)?
    
    func fetchNews(keyword: String, page: Int, pageSize: Int) {
        NetworkManager.shared.fetchNews(about: keyword, page: page, pageSize: pageSize) { (result: Result<NewsResponse, Error>) in
            switch result {
            case .success(let response):
                self.response = response
            case .failure(let error):
                // TODO: handle error with UI Alert
                print(error)
            }
        }
    }
    
    func saveToHistory(title: String, totalResults: Int, searchDate: String) {
        let item = SearchHistoryItem(title: title, totalResults: totalResults, searchDate: searchDate)
        HistoryDataManager.shared.saveSearchSearch(item)
    }
    
    func articleDidTapped(with urlString: String) {
        router?.showArticleInBrowser(urlString: urlString)
    }
    
    func historyButtonTapped() {
        router?.navigateToHistory()
    }
}
