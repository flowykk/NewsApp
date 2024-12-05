struct NewsResponse: Codable {

    let totalResults: Int?
    let articles: [Article]

    init() {
        totalResults = nil
        articles = []
    }
}
