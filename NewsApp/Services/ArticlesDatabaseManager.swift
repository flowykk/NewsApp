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
    func articleExists(withUrl url: String, completion: @escaping (Bool) -> ()) // Новый метод
}

final class ArticlesDatabaseManager: ArticlesDatabasePersistable {
    
    static var shared = ArticlesDatabaseManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
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
        articleExists(withUrl: article.url) { [weak self] exists in
            guard !exists else {
                print("Article with this URL already exists.")
                return
            }
            
            self?.context?.insert(article)
        }
    }
    
    func removeArticle(article: ArticleDTO) {
        do {
            guard let articles = try context?.fetch(FetchDescriptor<ArticleDTO>()) else { return }
            
            if let index = articles.firstIndex(where: { $0.url == article.url }) {
                let articleToDelete = articles[index]
                
                context?.delete(articleToDelete)
            } else {
                print("Article not found.")
            }
        } catch {
            print("Error fetching articles: \(error.localizedDescription)")
        }
    }
    
    func clearArticles() {
        do {
            try context?.delete(model: ArticleDTO.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func articleExists(withUrl url: String, completion: @escaping (Bool) -> ()) {
        let descriptor = FetchDescriptor<ArticleDTO>()
        
        do {
            let data = try context?.fetch(descriptor)
            guard let data else {
                completion(false)
                return
            }
            
            completion(data.contains(where: { $0.url == url }))
        } catch {
            completion(false)
        }
    }
}
