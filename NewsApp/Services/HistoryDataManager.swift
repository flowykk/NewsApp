import Foundation

protocol HistoryDataPersistable {
    func saveSearchSearch(_ search: SearchHistoryItem)
    func getSearches() -> [SearchHistoryItem]
    func removeSearch(_ search: SearchHistoryItem)
    func removeAllSearches()
}

final class HistoryDataManager: HistoryDataPersistable {
    
    static let shared = HistoryDataManager()
    
    private let searchHistoryKey = "searchHistoryKey"
    
    func saveSearchSearch(_ search: SearchHistoryItem) {
        var searches = getSearches()
        searches.append(search)
        
        if let encoded = try? JSONEncoder().encode(searches) {
            UserDefaults.standard.set(encoded, forKey: searchHistoryKey)
        }
    }
    
    func getSearches() -> [SearchHistoryItem] {
        if let savedData = UserDefaults.standard.data(forKey: searchHistoryKey),
            let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: savedData) {
                return decoded
        }
        
        return []
    }
    
    func removeSearch(_ search: SearchHistoryItem) {
        var searches = getSearches()
        
        if let index = searches.firstIndex(where: { $0.title == search.title }) {
            searches.remove(at: index)
        }
        
        if let encodedData = try? JSONEncoder().encode(searches) {
            UserDefaults.standard.set(encodedData, forKey: searchHistoryKey)
        }
    }
    
    func removeAllSearches() {
        UserDefaults.standard.removeObject(forKey: searchHistoryKey)
    }
}
