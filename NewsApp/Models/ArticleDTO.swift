import SwiftData

@Model
final class ArticleDTO {
    var url: String
    var sourceName: String
    var title: String
    var articleDescription: String
    var urlToImage: String
    var publishedAt: String
    
    init(
        url: String,
        sourceName: String,
        title: String,
        articleDescription: String,
        urlToImage: String,
        publishedAt: String
    ) {
        self.url = url
        self.sourceName = sourceName
        self.title = title
        self.articleDescription = articleDescription
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
}
