import SwiftData

protocol ArticlesDatabasePersistable {

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void)
    func saveArticle(article: Article)
    func removeArticle(article: Article)
    func clearArticles()
    func articleExists(withUrl url: String, completion: @escaping (Bool) -> Void)
}

final class SwiftDataArticlesStorage: ArticlesDatabasePersistable {

    static var shared = SwiftDataArticlesStorage()

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

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let descriptor = FetchDescriptor<ArticleDTO>()

        do {
            let data = try context?.fetch(descriptor)
            guard let data else {
                completion(.failure(StorageError.noData))
                return
            }
            completion(.success(data.map { $0.toDomain() }))
        } catch {
            completion(.failure(error))
        }
    }

    func saveArticle(article: Article) {
        guard let urlToArticle = article.url else { return }
        articleExists(withUrl: urlToArticle) { [weak self] exists in
            guard !exists else {
                print("Article with this URL already exists.")
                return
            }

            self?.context?.insert(ArticleDTO(from: article))
        }
    }

    func removeArticle(article: Article) {
        do {
            guard let articles = try context?.fetch(FetchDescriptor<ArticleDTO>()) else { return }

            guard let index = articles.firstIndex(where: { $0.url == article.url }) else { return }
            let articleToDelete = articles[index]
            context?.delete(articleToDelete)
        } catch {
            print(error.localizedDescription)
        }
    }

    func clearArticles() {
        do {
            guard let articles = try context?.fetch(FetchDescriptor<ArticleDTO>()) else { return }

            for article in articles {
                context?.delete(article)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func articleExists(withUrl url: String, completion: @escaping (Bool) -> Void) {
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
