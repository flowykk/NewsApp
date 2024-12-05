protocol SearchHistoryRepository {

    func fetchSearches() -> [SearchHistoryItem]
    func removeSearch(_ search: SearchHistoryItem)
    func clearSearches()
}
