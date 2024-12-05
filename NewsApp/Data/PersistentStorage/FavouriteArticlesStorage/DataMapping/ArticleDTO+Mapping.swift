import SwiftData

@Model
final class ArticleDTO {

    @Attribute(.unique)
    var url: String
    var sourceName: String
    var title: String
    var articleDescription: String
    var urlToImage: String
    var publishedAt: String

    init(from article: Article) {
        url = article.url ?? ""
        sourceName = article.source?.name ?? ""
        title = article.title ?? ""
        articleDescription = article.description ?? ""
        urlToImage = article.urlToImage ?? ""
        publishedAt = article.publishedAt ?? ""
    }
}

extension ArticleDTO {
    func toDomain() -> Article {
        .init(
            source: sourceName,
            title: title,
            description: articleDescription,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt
        )
    }
}
