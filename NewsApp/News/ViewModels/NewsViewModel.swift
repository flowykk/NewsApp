import Foundation
import NetworkKit

protocol NewsViewModelDelegate: AnyObject {
    var router: NewsRouterProtocol? { get set }
    var response: NewsResponse { get set }
    var didFetchedNews: ((NewsResponse) -> Void)? { get set }
    
    func fetchNews()
}

final class NewsViewModel: NewsViewModelDelegate {
    var router: NewsRouterProtocol?
    
    var response = NewsResponse() {
        didSet {
            didFetchedNews?(response)
        }
    }
    var didFetchedNews: ((NewsResponse) -> Void)?
    
    func fetchNews() {
        NetworkManager.shared.fetchNews(about: "ElonMusk", page: 1, pageSize: 100) { (result: Result<NewsResponse, Error>) in
            switch result {
            case .success(let response):
                self.response = response
            case .failure(let error):
                // TODO: handle error with UI Alert
                print(error)
            }
        }
    }
}
