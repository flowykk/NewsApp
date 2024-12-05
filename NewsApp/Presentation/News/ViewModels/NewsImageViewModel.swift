import UIKit
import NetworkKit

protocol NewsImageViewModelDelegate: AnyObject {

    var image: UIImage? { get set }
    var didFetchedNewsImage: ((UIImage?) -> Void)? { get set}

    func fetchNewsImage(for article: Article)
}

final class NewsImageViewModel: NewsImageViewModelDelegate {

    var image: UIImage? {
        didSet {
            didFetchedNewsImage?(image)
        }
    }
    var didFetchedNewsImage: ((UIImage?) -> Void)?

    func fetchNewsImage(for article: Article) {
        guard let imageURL = article.urlToImage else { return }

        NetworkManager.shared.fetchNewsImage(for: imageURL) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data)?.resize(toDimension: 512) else { return }
                self.image = image
                FileManagerImageStorage.shared.saveImage(
                    image: image,
                    urlToArticle: article.url ?? "",
                    folderName: "news_images"
                )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
