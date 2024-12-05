protocol NewsUseCase {
    func fetchNews(keyword: String, page: Int, pageSize: Int, sortBy: String?, language: String?, completion: @escaping (Result<NewsResponse, Error>) -> Void)
    func saveSearchHistory(title: String, totalResults: String, searchDate: String)
}

final class DefaultNewsUseCase: NewsUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func fetchNews(keyword: String, page: Int, pageSize: Int, sortBy: String?, language: String?, completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        repository.fetchNews(keyword: keyword, page: page, pageSize: pageSize, sortBy: sortBy, language: language, completion: completion)
    }
    
    func saveSearchHistory(title: String, totalResults: String, searchDate: String) {
        let item = SearchHistoryItem(title: title, totalResults: totalResults, searchDate: searchDate)
        repository.saveSearchHistory(item: item)
    }
}
