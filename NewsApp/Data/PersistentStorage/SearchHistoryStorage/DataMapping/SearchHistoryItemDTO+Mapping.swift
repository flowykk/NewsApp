import Foundation

struct SearchHistoryItemDTO: Codable {
    let title: String
    let totalResults: String
    let searchDate: String
}

extension SearchHistoryItemDTO {
    init(from searchHistoryItem: SearchHistoryItem) {
        title = searchHistoryItem.title
        totalResults = searchHistoryItem.totalResults
        searchDate = searchHistoryItem.searchDate
    }
}

extension SearchHistoryItemDTO {
    func toDomain() -> SearchHistoryItem {
        return .init(title: title, totalResults: totalResults, searchDate: searchDate)
    }
}
