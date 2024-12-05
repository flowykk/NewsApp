import Foundation

protocol HistoryDataPersistable {
    func saveSearch(_ search: SearchHistoryItem)
    func fetchSearches() -> [SearchHistoryItem]
    func removeSearch(_ search: SearchHistoryItem)
    func clearSearches()
}

final class UserDefaultsSearchHistoryStorage: HistoryDataPersistable {
    
    static let shared = UserDefaultsSearchHistoryStorage()
    private init() { }
    
    private let searchHistoryKey = "searchHistoryKey"
    
    func fetchSearches() -> [SearchHistoryItem] {
        let historyItemsList = loadHistoryItems()
        return historyItemsList.map { $0.toDomain() }
    }
    
    func saveSearch(_ search: SearchHistoryItem) {
        let newSearch = SearchHistoryItemDTO(from: search)
            
        var historyItemsList = loadHistoryItems()
        historyItemsList.insert(newSearch, at: 0)
        
        saveHistoryItems(historyItemsList)
    }
    
    func removeSearch(_ search: SearchHistoryItem) {
        var historyItemsList = loadHistoryItems()
        
        if let index = historyItemsList.firstIndex(where: { $0.title == search.title }) {
            historyItemsList.remove(at: index)
        }
        
        if let encodedData = try? JSONEncoder().encode(historyItemsList) {
            UserDefaults.standard.set(encodedData, forKey: searchHistoryKey)
        }
    }
    
    func clearSearches() {
        UserDefaults.standard.removeObject(forKey: searchHistoryKey)
    }
}

extension UserDefaultsSearchHistoryStorage {
    
    private func loadHistoryItems() -> [SearchHistoryItemDTO] {
        guard let savedData = UserDefaults.standard.data(forKey: searchHistoryKey),
              let historyItemsList = try? JSONDecoder().decode([SearchHistoryItemDTO].self, from: savedData) else {
            return []
        }
        return historyItemsList
    }

    private func saveHistoryItems(_ items: [SearchHistoryItemDTO]) {
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encodedData, forKey: searchHistoryKey)
    }
}
