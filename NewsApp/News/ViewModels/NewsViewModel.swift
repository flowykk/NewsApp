import Foundation
import NetworkKit

protocol NewsViewModelDelegate: AnyObject {
    
    var router: NewsRouterProtocol? { get set }
    var response: NewsResponse { get set }
    var didFetchedNews: ((NewsResponse) -> Void)? { get set }
    
    func fetchNews(keyword: String, needToSave: Bool)
    func saveToHistory(title: String, totalResults: String, searchDate: String)
    
    func articleDidTapped(with urlString: String)
    func historyButtonTapped()
    func favouritesButtonTapped()
}

extension NewsViewModelDelegate {
    
    func fetchNews(keyword: String, needToSave: Bool = false) {
        return fetchNews(keyword: keyword, needToSave: needToSave)
    }
}

final class NewsViewModel: NewsViewModelDelegate {
    
    // FIXME: to protocol
    var currentPage = 1
    let pageSize = 10
    var isLoading = false
    
    var router: NewsRouterProtocol?
    
    var response = NewsResponse() {
        didSet {
            didFetchedNews?(response)
        }
    }
    var didFetchedNews: ((NewsResponse) -> Void)?
    
    func fetchNews(keyword: String, needToSave: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        NetworkManager.shared.fetchNews(
            about: keyword,
            page: currentPage,
            pageSize: pageSize
        ) { (result: Result<NewsResponse, Error>) in
            switch result {
            case .success(let response):
                self.isLoading = false
                self.currentPage += 1
                
                self.response = response
                
                if needToSave {
                    self.saveToHistory(
                        title: keyword,
                        totalResults: "\(response.totalResults ?? 0) Results",
                        searchDate: Date().formattedDate()
                    )
                }
            case .failure(let error):
                // TODO: handle error with UI Alert
                self.isLoading = false
                print(error)
            }
        }
    }
    
    func saveToHistory(title: String, totalResults: String, searchDate: String) {
        let item = SearchHistoryItem(title: title, totalResults: totalResults, searchDate: searchDate)
        HistoryDataManager.shared.saveSearch(item)
    }
    
    func articleDidTapped(with urlString: String) {
        router?.showArticleInBrowser(urlString: urlString)
    }
    
    func historyButtonTapped() {
        router?.navigateToHistory()
    }
    
    func favouritesButtonTapped() {
        router?.navigateToFavourites()
    }
}
