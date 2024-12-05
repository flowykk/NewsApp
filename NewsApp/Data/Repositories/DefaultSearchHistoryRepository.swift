final class DefaultSearchHistoryRepository: SearchHistoryRepository {

    private let storage = UserDefaultsSearchHistoryStorage.shared

    func fetchSearches() -> [SearchHistoryItem] {
        return storage.fetchSearches()
    }

    func removeSearch(_ search: SearchHistoryItem) {
        storage.removeSearch(search)
    }

    func clearSearches() {
        storage.clearSearches()
    }
}
