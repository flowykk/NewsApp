protocol NewsRepository {

    func fetchNews(
        keyword: String,
        page: Int,
        pageSize: Int,
        sortBy: String?,
        language: String?,
        completion: @escaping (Result<NewsResponse, Error>) -> Void
    )
    func saveSearchHistory(item: SearchHistoryItem)
}
