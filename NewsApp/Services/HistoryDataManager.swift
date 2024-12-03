import Foundation

protocol HistoryDataPersistable {
    func saveSearch(_ search: SearchHistoryItem)
    func fetchSearches() -> [SearchHistoryItem]
    func removeSearch(_ search: SearchHistoryItem)
    func clearSearches()
}

final class HistoryDataManager: HistoryDataPersistable {
    
    static let shared = HistoryDataManager()
    private init() { }
    
    private let searchHistoryKey = "searchHistoryKey"
    
    func fetchSearches() -> [SearchHistoryItem] {
        if let savedData = UserDefaults.standard.data(forKey: searchHistoryKey),
            let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: savedData) {
                return decoded
        }
        
        return []
    }
    
    func saveSearch(_ search: SearchHistoryItem) {
        var searches = fetchSearches()
        searches.insert(search, at: 0)
        
        if let encoded = try? JSONEncoder().encode(searches) {
            UserDefaults.standard.set(encoded, forKey: searchHistoryKey)
        }
    }
    
    func removeSearch(_ search: SearchHistoryItem) {
        var searches = fetchSearches()
        
        if let index = searches.firstIndex(where: { $0.title == search.title }) {
            searches.remove(at: index)
        }
        
        if let encodedData = try? JSONEncoder().encode(searches) {
            UserDefaults.standard.set(encodedData, forKey: searchHistoryKey)
        }
    }
    
    func clearSearches() {
        UserDefaults.standard.removeObject(forKey: searchHistoryKey)
    }
}
