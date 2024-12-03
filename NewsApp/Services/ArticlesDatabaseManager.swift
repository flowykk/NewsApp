import Foundation
import SwiftData

enum FetchError: Error {
    case noData
}

protocol ArticlesDatabasePersistable {
    func fetchArticles(completion: @escaping (Result<[ArticleDTO], Error>) -> ())
    func saveArticle(article: ArticleDTO)
    func removeArticle(article: ArticleDTO)
    func clearArticles()
}

final class ArticlesDatabaseManager: ArticlesDatabasePersistable {
    
    static var shared = ArticlesDatabaseManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let schema = Schema([ArticleDTO.self])
            container = try ModelContainer(for: schema, configurations: [])
            
            if let container { context = ModelContext(container) }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchArticles(completion: @escaping (Result<[ArticleDTO], Error>) -> ()) {
        let descriptor = FetchDescriptor<ArticleDTO>()
        
        do {
            let data = try context?.fetch(descriptor)
            guard let data else {
                completion(.failure(FetchError.noData))
                return
            }
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveArticle(article: ArticleDTO) {
        context?.insert(article)
    }
    
    func removeArticle(article: ArticleDTO) {
        context?.delete(article)
    }
    
    func clearArticles() {
        do {
            try context?.delete(model: ArticleDTO.self)
        } catch {
            print(error.localizedDescription)
        }
    }
}
