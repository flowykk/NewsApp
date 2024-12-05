import NetworkKit

final class DefaultNewsRepository: NewsRepository {

    private let storage = UserDefaultsSearchHistoryStorage.shared

    func fetchNews(
        keyword: String,
        page: Int,
        pageSize: Int,
        sortBy: String?,
        language: String?,
        completion: @escaping (Result<NewsResponse, Error>) -> Void
    ) {
        NetworkManager.shared.fetchNews(
            keyword: keyword,
            page: page,
            pageSize: pageSize,
            sortBy: sortBy,
            language: language
        ) { (result: Result<NewsResponse, Error>) in
            completion(result)
        }
    }

    func saveSearchHistory(item: SearchHistoryItem) {
        storage.saveSearch(item)
    }
}
